#!/bin/bash
# Quick setup script for PythonAnywhere
# Run this after cloning the repository and creating virtual environment

echo "🚀 Starting Web Structures Course deployment..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Check if we're in the right directory
if [ ! -f "manage.py" ]; then
    echo "❌ manage.py not found. Are you in the project root directory?"
    exit 1
fi

echo -e "${YELLOW}Step 1: Installing dependencies...${NC}"
pip install -r requirements.txt
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Step 2: Create .env if it doesn't exist
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}Step 2: Creating .env file...${NC}"
    echo "# Copy from .env.example and fill in your values" > .env
    echo "SECRET_KEY=django-insecure-your-secret-key-here" >> .env
    echo "DEBUG=False" >> .env
    echo "ALLOWED_HOSTS=your_username.pythonanywhere.com" >> .env
    echo -e "${GREEN}✓ .env created (please edit with your settings)${NC}"
    echo -e "${YELLOW}⚠️  Edit .env with your actual values before continuing${NC}"
    echo ""
    read -p "Press enter when .env is configured..."
else
    echo -e "${GREEN}✓ .env already exists${NC}"
fi

echo ""
echo -e "${YELLOW}Step 3: Running migrations...${NC}"
python manage.py migrate
echo -e "${GREEN}✓ Database migrated${NC}"
echo ""

echo -e "${YELLOW}Step 4: Collecting static files...${NC}"
python manage.py collectstatic --noinput
echo -e "${GREEN}✓ Static files collected${NC}"
echo ""

echo -e "${YELLOW}Step 5: Creating superuser...${NC}"
python manage.py createsuperuser
echo -e "${GREEN}✓ Superuser created${NC}"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment setup complete! ✅${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Go to PythonAnywhere Web tab"
echo "2. Configure Virtualenv path: /home/username/.virtualenvs/myenv"
echo "3. Configure Source code path: /home/username/web-structures-course"
echo "4. Edit WSGI file (see DEPLOYMENT_GUIDE.md)"
echo "5. Click Reload"
echo ""
echo "Your site will be available at: https://username.pythonanywhere.com"
