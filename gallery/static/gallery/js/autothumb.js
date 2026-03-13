import * as THREE from 'three';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';

export function generateThumbnail(file) {
    return new Promise((resolve, reject) => {
        // Создаем временную ссылку на файл
        const url = URL.createObjectURL(file);
        
        // 1. Настройка сцены (Off-screen render)
        const width = 300;
        const height = 200;

        const scene = new THREE.Scene();
        scene.background = new THREE.Color(0xffffff); // Белый фон
        const camera = new THREE.PerspectiveCamera(45, width / height, 0.1, 100);
        // ВАЖНО: preserveDrawingBuffer нужен для скриншота
        const renderer = new THREE.WebGLRenderer({ antialias: true, preserveDrawingBuffer: true, alpha: false });
        renderer.setSize(width, height);
        renderer.outputColorSpace = THREE.SRGBColorSpace;

        // Свет
        const ambientLight = new THREE.AmbientLight(0xffffff, 1.5);
        scene.add(ambientLight);
        const dirLight = new THREE.DirectionalLight(0xffffff, 1.5);
        dirLight.position.set(5, 10, 7);
        scene.add(dirLight);

        // 2. Загрузка модели
        const loader = new GLTFLoader();
        loader.load(
            url,
            (gltf) => {
                const model = gltf.scene;
                
                // Центруем модель
                const box = new THREE.Box3().setFromObject(model);
                const center = box.getCenter(new THREE.Vector3());
                const size = box.getSize(new THREE.Vector3());
                const maxDim = Math.max(size.x, size.y, size.z);
                model.position.sub(center);
                scene.add(model);
                
                // Позиционируем камеру
                const fov = camera.fov * (Math.PI / 180);
                let cameraZ = Math.abs(maxDim / 2 / Math.tan(fov / 2)) * 1.5;
                camera.position.set(cameraZ * 0.5, cameraZ * 0.5, cameraZ);
                camera.lookAt(0, 0, 0);
                
                // 3. Рендер кадра
                renderer.render(scene, camera);
                
                // 4. Захват как Data URL
                const dataURL = renderer.domElement.toDataURL('image/jpeg', 0.85);
                
                // 5. Очищаем ресурсы
                URL.revokeObjectURL(url);
                renderer.dispose();
                
                resolve(dataURL);
            },
            undefined,
            (error) => {
                URL.revokeObjectURL(url);
                console.error('Ошибка загрузки модели:', error);
                reject(error);
            }
        );
    });
}