from PIL import Image

tokens = open("frame.ppm").read().split()[4:]   
dados = bytes(int(t) for t in tokens)
Image.frombytes("RGB", (640, 480), dados).save("frame.png")
print("frame.png criado")