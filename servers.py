import uvicorn,torch
import io,re,base64,torch
import numpy as np
from typing import Union
from fastapi import FastAPI, Form
from pydantic import BaseModel
from PIL import Image
import os
os.environ['TORCH_HOME'] = '.'

#將base64字串轉換為PIL的image物件
def base64_to_image(base64_str, image_path=None):
    base64_data = re.sub('^data:image/.+;base64,', '', base64_str)
    byte_data = base64.b64decode(base64_data)
    image_data = io.BytesIO(byte_data)
    img = Image.open(image_data).convert("RGB")
    if image_path: 
        img.save(image_path)
    return img

#設定一個FastAPI的實例
app = FastAPI()

#測試連接
@app.get("/")
def read_root():
    return {"Hello": "World"}


# 處理上傳圖片的POST請求
@app.post("/upload")
def upload(
    Model_name: str = Form(...),
    base64_str: str = Form(...),
    Deep_model: str = Form(...)):

    try:
        Deep_model = eval(Deep_model)

        # 從字典中取出選定的模型
        model = models[Model_name]
        # 將模型移動到GPU上
        model.to("cuda")

        # 將base64字串轉換為PIL的image物件
        img_PIL = base64_to_image(base64_str)

        # 使用YOLOv5模型預測圖片中的物件
        outputs = model(np.array(img_PIL)).pandas().xyxy[0]
        results = {}

        # 如果使用ZoeDepth模型，則需要估算圖片中的物體深度
        if Deep_model:
            # 使用ZoeDepth模型估算深度，並將結果轉換為numpy數組
            depth_numpy = zoe.infer_pil(img_PIL)  
            # 將深度值轉換為介於0到255之間的整數
            depth_int = (255 * (depth_numpy - depth_numpy.min()) / (depth_numpy.max() - depth_numpy.min())).astype(np.uint8)

            # 對於YOLOv5模型預測的每一個物體，都進行深度估算
            for i, co in outputs.iterrows():
                y1,y2 = int(co['ymin']), int(co['ymax'])
                x1,x2 = int(co['xmin']), int(co['xmax'])
                deep = int(np.median(depth_int[y1:y2, x1:x2]))
                results[str(i)] = {c: str(co[c]) for c in co.index}
                results[str(i)]['deep'] = str(deep)
        else:
            # 如果不使用ZoeDepth模型，則直接將YOLOv5模型預測結果轉換為字典格式
            for i, co in outputs.iterrows():
                results[str(i)] = {c: str(co[c]) for c in co.index}
    except Exception as e:
        return {"message": f"{e}"}

    return bytes(str(results), "utf-8")
if __name__ == "__main__":

    models={}

    print('>>>>> 讀取YOLOv5 <<<<<')
    models['LK FAB'] = torch.hub.load(
        repo_or_dir = 'yolov5',
        model = 'custom', 
        path='models/TC3_PPE.pt', 
        source='local')
    
    print('>>>>> 讀取ZoeDepth距離檢測模型 <<<<<')
    model_zoe_n = torch.hub.load(repo_or_dir = ".", model = "ZoeD_N", source="local", pretrained=True)
        
    DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
    print(f'>>>>> 使用{DEVICE}進行運算 <<<<<')
    
    zoe = model_zoe_n.to(DEVICE)

    uvicorn.run(app, host='127.0.0.1', port=5001)