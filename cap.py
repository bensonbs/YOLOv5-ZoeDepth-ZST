import cv2

IPs = [
    'rtsp://admin:123456@192.168.5.115:554/profile1',
    'rtsp://admin:123456@192.168.5.116:554/profile1',
    'rtsp://admin:123456@192.168.5.117:554/profile1',
    'rtsp://admin:123456@192.168.5.118:554/profile1',
    'rtsp://admin:123456@192.168.5.57:554/profile1',
    'rtsp://admin:123456@192.168.5.58:554/profile1',
    'rtsp://admin:123456@192.168.5.94:554/profile1',
    
]

for i, IP in enumerate(IPs):
    cap = cv2.VideoCapture(IP)
    ret, frame = cap.read()
    frame = cv2.resize(frame, (640, 640))
    print(IP,ret)

    if ret:
        cv2.imwrite(f'{i}.png',frame)