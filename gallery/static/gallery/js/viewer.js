// gallery/static/gallery/js/viewer.js
import * as THREE from 'three';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { RoomEnvironment } from 'three/addons/environments/RoomEnvironment.js';

export function loadModel(containerId, modelUrl) {
    const container = document.getElementById(containerId);
    if (!container) {
        console.error('Контейнер не найден:', containerId);
        return;
    }

    // 1. Сцена, камера, рендерер
    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0xf5f5f5);

    const camera = new THREE.PerspectiveCamera(45, container.clientWidth / container.clientHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
    renderer.setSize(container.clientWidth, container.clientHeight);
    renderer.setPixelRatio(window.devicePixelRatio);
    // Correct color space for GLTF/metalness
    renderer.outputColorSpace = THREE.SRGBColorSpace;
    // Tone mapping for cinematic look
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1.0;

    container.innerHTML = '';
    container.appendChild(renderer.domElement);

    // 2. Контролы (OrbitControls)
    const controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.dampingFactor = 0.05;
    controls.minDistance = 0.5;
    controls.maxDistance = 20;

    // 3. Профессиональное окружение (RoomEnvironment -> PMREM)
    const pmremGenerator = new THREE.PMREMGenerator(renderer);
    pmremGenerator.compileEquirectangularShader();
    const roomEnvironment = new RoomEnvironment();
    scene.environment = pmremGenerator.fromScene(roomEnvironment).texture;
    // 4. Генерируем HTML лоадера программно
    const loaderDiv = document.createElement('div');
    loaderDiv.className = 'loader-overlay';
    loaderDiv.innerHTML = `
        <div style="color: #666; font-size: 0.9rem;">Loading...</div>
        <div class="progress-bar">
            <div class="progress-fill"></div>
        </div>
    `;
    container.appendChild(loaderDiv);
    const progressFill = loaderDiv.querySelector('.progress-fill');

    // 5. Загрузка модели
    const loader = new GLTFLoader();
    let loadedModel = null;
    loader.load(
        modelUrl,
        // onLoad
        (gltf) => {
            loadedModel = gltf.scene;
            fitCameraToObject(camera, loadedModel, controls);
            scene.add(loadedModel);
            // Скрываем лоадер
            loaderDiv.style.opacity = '0';
            setTimeout(() => loaderDiv.remove(), 300);
        },
        // onProgress
        (xhr) => {
            if (xhr.total > 0 && progressFill) {
                const percent = (xhr.loaded / xhr.total) * 100;
                progressFill.style.width = percent + '%';
            }
        },
        // onError
        (error) => {
            console.error('Ошибка загрузки:', error);
            loaderDiv.innerHTML = `<div class="error-msg">❌ Ошибка загрузки<br><small>Проверьте файл</small></div>`;
        }
    );

    // 4. Анимация
    function animate() {
        requestAnimationFrame(animate);
        controls.update();
        // Авто-вращение отключено, но можно включить при желании
        // if (loadedModel) loadedModel.rotation.y += 0.005;
        renderer.render(scene, camera);
    }
    animate();

    // Resize handler
    window.addEventListener('resize', () => {
        camera.aspect = container.clientWidth / container.clientHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(container.clientWidth, container.clientHeight);
    });
}

function fitCameraToObject(camera, object, controls, offset = 1.25) {
    const boundingBox = new THREE.Box3();
    boundingBox.setFromObject(object);
    const center = boundingBox.getCenter(new THREE.Vector3());
    const size = boundingBox.getSize(new THREE.Vector3());
    const maxDim = Math.max(size.x, size.y, size.z);

    object.position.x = -center.x;
    object.position.y = -center.y;
    object.position.z = -center.z;

    const fov = camera.fov * (Math.PI / 180);
    let cameraZ = Math.abs(maxDim / 2 / Math.tan(fov / 2));
    cameraZ *= offset;
    camera.position.set(0, maxDim * 0.5, cameraZ);
    camera.lookAt(0, 0, 0);
    camera.updateProjectionMatrix();
    // Если передан объект controls — обновляем его цель
    if (controls && typeof controls.target !== 'undefined') {
        controls.target.set(0, 0, 0);
        controls.update();
    }
}
