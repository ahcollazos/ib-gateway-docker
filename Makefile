# Variables
IMAGE_NAME=ib-gateway
PLATFORM=linux/amd64
AWS_REGION=us-east-1
AWS_ACCOUNT_ID=818079790045
ECR_REPO=$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME)
BUILD_CONTEXT=latest

.PHONY: build push login ecr-tag deploy

# 1. Construir la imagen localmente
build:
	@echo "🐳 Construyendo imagen Docker para $(IMAGE_NAME)..."
	docker buildx build --platform=$(PLATFORM) -t $(IMAGE_NAME):latest ./$(BUILD_CONTEXT) --load

# 2. Login en Amazon ECR
login:
	@echo "🔐 Login en Amazon ECR..."
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

# 3. Etiquetar imagen para ECR
ecr-tag:
	@echo "🏷️ Etiquetando imagen para ECR como $(ECR_REPO):latest..."
	docker tag $(IMAGE_NAME):latest $(ECR_REPO):latest

# 4. Hacer push a ECR
push:
	@echo "📤 Subiendo imagen a ECR..."
	docker push $(ECR_REPO):latest

# 5. Flujo completo
deploy: build login ecr-tag push
	@echo "✅ Imagen subida correctamente a $(ECR_REPO):latest"
