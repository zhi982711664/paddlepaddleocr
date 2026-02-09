FROM paddlepaddle/paddle:3.3.0

# 屏蔽GPU环境变量
ENV CUDA_VISIBLE_DEVICES=-1

WORKDIR /paddleocr

# 安装依赖
RUN apt update && apt install -y git wget && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir paddleocr==2.7.0 fastapi uvicorn pillow numpy opencv-python-headless python-multipart -i https://pypi.tuna.tsinghua.edu.cn/simple

# 下载源码和模型
RUN git clone https://github.com/PaddlePaddle/PaddleOCR.git .
RUN mkdir -p /paddleocr/inference && cd /paddleocr/inference && \
    wget https://paddleocr.bj.bcebos.com/PP-OCRv4/chinese/ch_PP-OCRv4_det_infer.tar && tar xf ch_PP-OCRv4_det_infer.tar && \
    wget https://paddleocr.bj.bcebos.com/PP-OCRv4/chinese/ch_PP-OCRv4_rec_infer.tar && tar xf ch_PP-OCRv4_rec_infer.tar

EXPOSE 8866

# 启动服务时强制CPU
CMD ["python", "deploy/paddleocr_server.py", "--use_gpu=False", "--port=8866"]
