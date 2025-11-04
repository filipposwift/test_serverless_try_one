# Clean base image containing only ComfyUI, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base-cuda12.8.1

# -----------------------------------------------------------
# 1️⃣ Install custom nodes
# -----------------------------------------------------------
RUN comfy-node-install \
    ComfyUI-GGUF \
    rgthree-comfy \
    comfyui-kjnodes \
    comfyui-easy-use \
    comfyui-custom-scripts \
    controlaltai-nodes \
    https://github.com/1038lab/ComfyUI-JoyCaption.git \
    https://github.com/tsogzark/comfyui-load-image-from-url.git

# -----------------------------------------------------------
# 2️⃣ Download Wan 2.2 core models
# -----------------------------------------------------------
RUN mkdir -p /ComfyUI/models/text_encoders /ComfyUI/models/vae /ComfyUI/models/diffusion_models && \
    echo "⬇️ Downloading Text Encoder..." && \
    wget --tries=3 --retry-connrefused --waitretry=5 \
         -O /ComfyUI/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors \
         https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors && \
    echo "⬇️ Downloading VAE..." && \
    wget --tries=3 --retry-connrefused --waitretry=5 \
         -O /ComfyUI/models/vae/wan_2.1_vae.safetensors \
         https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors && \
    echo "⬇️ Downloading GGUF diffusion model (QuantStack)..." && \
    wget --tries=3 --retry-connrefused --waitretry=5 \
         -O /ComfyUI/models/diffusion_models/Wan2.2-T2V-A14B-LowNoise-Q8_0.gguf \
         https://huggingface.co/QuantStack/Wan2.2-T2V-A14B-GGUF/resolve/main/LowNoise/Wan2.2-T2V-A14B-LowNoise-Q8_0.gguf

# -----------------------------------------------------------
# 3️⃣ Download Upscaler
# -----------------------------------------------------------
RUN mkdir -p /ComfyUI/models/upscale && \
    echo "⬇️ Downloading Upscaler..." && \
    wget --tries=3 --retry-connrefused --waitretry=5 \
         -O /ComfyUI/models/upscale/4x_NMKD-Siax_200k.pth \
         https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth

# -----------------------------------------------------------
# 4️⃣ Download LoRA models
# -----------------------------------------------------------
RUN mkdir -p /ComfyUI/models/loras && \
    echo "⬇️ Downloading Mich3lle LoRA..." && \
    wget --tries=3 --retry-connrefused --waitretry=5 \
         -O /ComfyUI/models/loras/Wan2.2_Low_Mich3lle.safetensors \
         https://huggingface.co/filipposwift/Mich3lle_LoRA/resolve/main/Wan2.2_Low_Mich3lle.safetensors && \
    echo "⬇️ Downloading Wan2.2 Lightning LoRA..." && \
    wget --tries=3 --retry-connrefused --waitretry=5 \
         -O /ComfyUI/models/loras/low_noise_model.safetensors \
         https://huggingface.co/lightx2v/Wan2.2-Lightning/resolve/main/Wan2.2-T2V-A14B-4steps-lora-rank64-Seko-V1.1/low_noise_model.safetensors
