FROM runpod/worker-comfyui:5.7.1-base

ARG XFLUX_COMMIT=2897c0a

RUN cd /comfyui/custom_nodes && \
	git clone --no-checkout --depth 1 https://github.com/XLabs-AI/x-flux-comfyui.git x-flux-comfyui && \
	cd x-flux-comfyui && \
	git fetch --depth 1 origin ${XFLUX_COMMIT} && \
	git checkout ${XFLUX_COMMIT} && \
	python -m pip install --no-cache-dir .

RUN mkdir -p /comfyui/models/clip_vision && \
	wget -O /comfyui/models/clip_vision/clip_l_vision_openai.safetensors \
	https://huggingface.co/openai/clip-vit-large-patch14/resolve/main/model.safetensors

RUN mkdir -p /comfyui/models/xlabs/ipadapters && \
	wget -O /comfyui/models/xlabs/ipadapters/ip_adapter.safetensors \
	https://huggingface.co/XLabs-AI/flux-ip-adapter/resolve/main/ip_adapter.safetensors

COPY workflow.json /comfyui/workflows/workflow.json
COPY handler.py /handler.py

RUN sed -i 's/--log-stdout/--log-stdout --highvram/g' /start.sh

RUN mkdir -p /comfyui/models/checkpoints /comfyui/models/loras && \
	ln -s /runpod-volume/ComfyUI/models/checkpoints/flux1-dev-fp8.safetensors \
	/comfyui/models/checkpoints/flux1-dev-fp8.safetensors && \
	ln -s /runpod-volume/ComfyUI/models/loras/insta_nsfw_V1.safetensors \
	/comfyui/models/loras/insta_nsfw_V1.safetensors