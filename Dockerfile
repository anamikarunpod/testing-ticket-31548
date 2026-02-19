FROM runpod/worker-comfyui:5.7.1-base

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/XLabs-AI/x-flux-comfyui.git && \
    cd x-flux-comfyui && \
    python setup.py

RUN mkdir -p /comfyui/models/clip_vision && \
    wget -O /comfyui/models/clip_vision/clip_l_vision_openai.safetensors \
    https://huggingface.co/openai/clip-vit-large-patch14/resolve/main/model.safetensors

RUN mkdir -p /comfyui/models/xlabs/ipadapters && \
    wget -P /comfyui/models/xlabs/ipadapters/ https://huggingface.co/XLabs-AI/flux-ip-adapter/resolve/main/ip_adapter.safetensors

COPY workflow.json /comfyui/workflows/workflow.json
COPY handler.py /handler.py
RUN sed -i 's/--log-stdout/--log-stdout --highvram/g' /start.sh

RUN mkdir -p /comfyui/models/checkpoints /comfyui/models/loras && \
    ln -s /runpod-volume/ComfyUI/models/checkpoints/flux1-dev-fp8.safetensors \
          /comfyui/models/checkpoints/flux1-dev-fp8.safetensors && \
    ln -s /runpod-volume/ComfyUI/models/loras/insta_nsfw_V1.safetensors \
          /comfyui/models/loras/insta_nsfw_V1.safetensors