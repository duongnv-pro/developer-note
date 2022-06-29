<!-- @format -->

# Docker Tutorial

- [Back](../README.md)

## Dockerize ứng dụng Python, Flask

> https://viblo.asia/p/dockerize-ung-dung-python-flask-bWrZnxbY5xw

### Build Docker Image

#### Cấu hình docker file

Dockerfile

```dockerfile
FROM python:3.6-alpine

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

CMD ["python", "app.py"]
```

Giải thích:

- Dòng đầu tiên **FROM**: ta bắt đầu từ 1 Image có môi trường Alpint và đã cài sẵn Python phiên bản 3.6.
- Tiếp theo trong file Dockerfile ta có **WORKDIR**: ý là ta sẽ chuyển đến đường dẫn là **/app** bên trong Image, nếu đường dẫn này không tồn tại thì sẽ tự động được tạo luôn nhé
- Tiếp theo ta **COPY** toàn bộ file từ folder ở môi trường gốc (bên ngoài - folder **docker-python**) và đưa vào trong đường dẫn **/app** bên trong Image
- Tiếp tới là ta cài đặt dependencies, cần cài những thứ gì thì ta đề cập sẵn ở file **requirements.txt** rồi (câu lệnh này các bạn có thể xem nó xêm xêm như npm install trong NodeJS nhé)
- Cuối cùng là ta dùng **CMD** để chỉ command mặc định khi một container được khởi tạo từ Image: ở đây ta sẽ khởi động file app.py

#### Build Docker Image

```bash
docker build -t learning-docker/python:v1 .
```

Dấu "chấm" ở cuối ý bảo Docker là "tìm file Dockerfile ở thư mục hiện tại và build" nhé

Sau khi quá trình build Image thành công, các bạn có thể kiểm tra bằng command:

```bash
docker images
```

#### Chạy Project

Vẫn ở folder **docker-python**, các bạn tạo file **docker-compose.yml**, với nội dung như sau:

```yml
version: "3.7"

services:
  app:
    image: learning-docker/python:v1
    ports:
      - "5000:5000"
    restart: unless-stopped
```

Giải thích nhanh:

- Ta định nghĩa 1 service tên là **app**, service này khi chạy sẽ tạo ra 1 container tương ứng, container được tạo từ image với tên chúng ta đã chọn.
- Ta **map port** từ cổng 5000 ở máy gốc (bên ngoài) vào cổng 5000 bên trong container, vì project của chúng ta được chạy ở cổng 5000 (mặc định của Flask)

Để khởi động project các bạn chạy command sau:

```bash
docker-compose up
```

Các bạn sửa lại file app.py một chút như sau nhé:

```py
from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def hello():
    return render_template('index.html', title='Docker Python', name='James')

if __name__ == "__main__":
    app.run(host="0.0.0.0")
```

Ở trên ta chỉ thêm vào duy nhất **host=0.0.0.0** để nói với project chúng ta là "chấp nhận cho tất cả mọi IP truy cập"

```bash
docker build -t learning-docker/python:v1 .
docker-compose down
docker-compose up
```

#### Biến môi trường (ENV)

Bài trước và bài các bạn có thể thấy là project khi chạy đều được fix cứng 1 cổng (bài trước là 3000, bài này là 5000), thế nếu ta muốn container chạy ở một cổng khác thì ta lại phải sửa code hay sao??

Lúc đó ta sẽ nghĩ tới **biến môi trường (environment variable)**, trong quá trình dev và khi chạy thật tế sử dụng biến môi trường sẽ giúp ta rất nhiều trong việc giảm tối thiểu việc phải sửa code

#### Biến môi trường ở Dockerfile

Đầu tiên là ta sẽ thử dùng biến môi trường khai báo ở Dockerfile để thiết lập Port(cổng) cho project chạy trong container nhé (ý là container sẽ không chạy ở port 5000 nữa)

```py
from flask import Flask, render_template
import os

app = Flask(__name__)

@app.route("/")
def hello():
    return render_template('index.html', title='Docker Python', name='James')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=os.environ['PORT']) # Chạy project ở PORT nhận vào từ biến môi trường
```

Sau đó ở file Dockerfile ta sửa lại như sau:

```dockerfile
FROM python:3.6-alpine

WORKDIR /app

# Tạo ra biến môi trường tên là PORT với giá trị 5555
ENV PORT 5555

COPY . .

RUN pip install -r requirements.txt

CMD ["python", "app.py"]
```

Ở file docker-compose.yml ta sửa lại chút như sau nhé:

```yml
version: "3.7"

services:
  app:
    image: learning-docker/python:v1
    ports:
      - "5000:5555"
    restart: unless-stopped
```

```bash
docker build -t learning-docker/python:v1 .
docker-compose down
docker-compose up
```

#### Biến môi trường ở docker-compose

Để không phải build lại image mỗi lần ta đổi port, ta sẽ khai báo biến môi trường ở docker-compose.yml nhé. Tại sao:

- Biến môi trường ở file Dockerfile sẽ được khai báo khi ta build image
- Biến môi trường ở file docker-compose.yml sẽ được khởi tạo khi container được khởi tạo, tức là khi ta chạy docker-compose up. Do đó để thay đổi biến môi trường ta chỉ cần down và up là xong

Ở file Dockerfile ta xóa dòng ENV PORT 5555 đi nhé.
Sau đó ở file docker-compose.yml ta sửa lại như sau:

```yml
version: "3.7"

services:
  app:
    image: learning-docker/python:v1
    ports:
      - "5000:6666"
    restart: unless-stopped
    environment:
      PORT: 6666
```

Bây giờ ta vẫn cần build lại image 1 lần để cập nhật mới được áp dụng:

```bash
docker build -t learning-docker/python:v1 .
docker-compose down
docker-compose up
```

#### Cách tốt hơn để tạo biến môi trường

Ở ví dụ trên nếu ta muốn đổi PORT thành 7777 chẳng hạn, ta phải sửa ở 2 nơi trong file docker-compose.yml, vậy nếu biến đó dùng ở 100 nơi trong file docker-compose.yml thì sao?
**docker-compose** support ta một cách đơn giản hơn, tiện hơn để khởi tạo biến môi trường, đó là đặt ở file **.env**
Khi chạy project thì **docker-compose** sẽ tự tìm xem có file **.env** hay không và load các biến trong đó.
Ở folder docker-python ta tạo file .env với nôi dung như sau:

```.env
PORT=8888
PUBLIC_PORT=9999
```

Giải thích:

- biến **PORT**: chỉ port của project chạy **bên trong** container
- biến **PUBLIC_PORT**: chỉ port mà "thế giới bên ngoài" dùng để truy cập vào project

Ta sửa lại file docker-compose.yml như sau:

```yml
version: "3.4"

services:
  app:
    image: learning-docker/python:v1
    ports:
      - "${PUBLIC_PORT}:${PORT}"
    restart: unless-stopped
    environment:
      PORT: ${PORT}
```

Sau đó ta khởi động lại project nhé:

```bash
docker-compose down
docker-compose up
```
