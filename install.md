# 🚀 ib-gateway ECR Deployment - Setup Guide

Este documento resume todos los pasos exitosos realizados para construir y desplegar la imagen Docker de `ib-gateway` hacia Amazon ECR.

---

## ✅ Resumen de pasos realizados

### 1. 🔁 Clonado del repositorio

Se clonó el fork del repositorio original:

```bash
git clone https://github.com/ahcollazos/ib-gateway-docker.git
cd ib-gateway-docker
```

---

### 2. 🔧 Correcciones iniciales

- Se corrigió el valor incorrecto de plataforma (`linux/arn64` ➜ `linux/amd64`) en `docker-compose.yml`.
- Se confirmó que el `Dockerfile` está dentro del subdirectorio `./latest`.

---

### 3. 🐳 Construcción de imagen Docker local

Se usó el comando adecuado para sistemas Apple Silicon:

```bash
docker buildx build --platform linux/amd64 -t ghcr.io/gnzsnz/ib-gateway:latest ./latest --load
```

o simplemente con `docker compose`:

```bash
docker compose build
```

---

### 4. 🔐 Configuración de credenciales IB

Se utilizó un archivo `.env` con las siguientes variables:

```env
TWS_USERID=andresco2024
TWS_PASSWORD=*******
TRADING_MODE=paper
READ_ONLY_API=no
VNC_SERVER_PASSWORD=clavevnc
TWOFA_TIMEOUT_ACTION=restart
RELOGIN_AFTER_TWOFA_TIMEOUT=yes
TIME_ZONE=America/Bogota
```

El archivo `.env` fue referenciado automáticamente por `docker-compose.yml` para pasar las variables al contenedor.

Se agregó a `.gitignore` para evitar exposición de credenciales.

---

### 5. 📦 Creación de repositorio en Amazon ECR

Se creó un repositorio llamado `ib-gateway` con escaneo de imágenes activado:

```bash
aws ecr create-repository   --repository-name ib-gateway   --image-scanning-configuration scanOnPush=true   --region us-east-1
```

El URI generado fue:

```
818079790045.dkr.ecr.us-east-1.amazonaws.com/ib-gateway
```

---

### 6. 🧰 Makefile para automatizar build y push

Se creó un `Makefile` que permite:

- Construir la imagen
- Hacer login en ECR
- Etiquetar
- Subir la imagen

Comando principal:

```bash
make deploy
```

---

## ✅ Estado final

- Imagen `ghcr.io/gnzsnz/ib-gateway:latest` construida correctamente
- Credenciales IB cargadas con `.env`
- Imagen publicada en ECR bajo el nombre:  
  `818079790045.dkr.ecr.us-east-1.amazonaws.com/ib-gateway:latest`

---

**Próximo paso sugerido:** desplegar esta imagen en la instancia EC2 configurada.