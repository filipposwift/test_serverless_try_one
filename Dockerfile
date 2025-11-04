# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base-cuda12.8.1

# install custom nodes into comfyui
RUN comfy-node-install ComfyUI-GGUF rgthree-comfy comfyui-kjnodes comfyui-easy-use comfyui-custom-scripts controlaltai-nodes https://github.com/1038lab/ComfyUI-JoyCaption.git https://github.com/tsogzark/comfyui-load-image-from-url.git


# download models and put them into the correct folders in comfyui
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors --relative-path models/text_encoders --filename umt5_xxl_fp8_e4m3fn_scaled.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors --relative-path models/vae --filename wan_2.1_vae.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_t2v_14B_bf16.safetensors --relative-path models/diffusion_models --filename Wan2.2-T2V-A14B-LowNoise-Q8_0.gguf

# download upscaler with wget
RUN mkdir -p /ComfyUI/models/upscale && \
    wget --tries=3 --retry-connrefused --waitretry=5 -O /ComfyUI/models/upscale/4x_NMKD-Siax_200k.pth \
    https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth


# download loras
RUN mkdir -p /ComfyUI/models/loras && \
    wget --tries=3 --retry-connrefused --waitretry=5 \
         -O /ComfyUI/models/loras/Wan2.2_Low_Mich3lle.safetensors \
         https://huggingface.co/filipposwift/Mich3lle_LoRA/resolve/main/Wan2.2_Low_Mich3lle.safetensors && \
    wget --tries=3 --retry-connrefused --waitretry=5 \
         -O /ComfyUI/models/loras/low_noise_model.safetensors \
         https://huggingface.co/lightx2v/Wan2.2-Lightning/resolve/main/Wan2.2-T2V-A14B-4steps-lora-rank64-Seko-V1.1/low_noise_model.safetensors
