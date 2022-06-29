<!-- @format -->

# Docker Tutorial

- [Back](../README.md)

## Dockerize ứng dụng NodeJS

### Cấu hình Dockerfile

Vấn ở trong folder **docker-node**, cả bài này chúng ta sẽ chỉ thao tác với folder này nhé. Các bạn tạo 1 file tên là `Dockerfile` với nội dung như sau:

```Dockerfile
FROM node:latest

WORKDIR /app

COPY . .

RUN npm install

CMD ["npm", "start"]

```

- Ở đầu mỗi file Dockerfile ta luôn phải có FROM. FROM ý chỉ ta bắt đầu từ môi trường nào, môi trường này phải đã được build thành Image. Ở đây ta bắt đầu từ môi trường với Image có tên là `node:latest`, đây là Image đã được build sẵn và chính thức (official) từ team của NodeJS, Ở môi trường này ta có sẵn phiên bản NodeJS mới nhất (latest), hiện tại là 13.2.
- Tiếp theo ta có từ khoá **WORKDIR**. Ý chỉ ở bên trong image này, tạo ra cho tôi folder tên là `app` và chuyển tôi đến đường dẫn `/app`. WORKDIR các bạn có thể coi nó tương đương với câu lệnh **mkdir /app && cd /app** (đường dẫn này các bạn có thể đặt tuỳ ý nhé, ở đây mình chọn là app)
- Tiếp theo ta có câu lệnh `COPY` và các bạn để ý thấy ta có 2 dấu "chấm", trông kì ta. 😄. Ý dòng này là: Copy toàn bộ code ở môi trường gốc, tức ở folder **docker-node** hiện tại vào bên trong Image ở đường dẫn **/app**.
- Tiếp theo ta có câu lệnh `RUN`. RUN để chạy một câu lệnh nào đó khi build Docker Image, ở đây ta cần chạy `npm install` để cài dependencies, như bao project NodeJS khác. Các bạn thật chú ý cho mình là RUN chạy khi BUILD thôi nhé, và vì chạy khi build nên nó chỉ được chạy 1 lần trong lúc build, chú ý điều này để thấy sự khác biệt với CMD mình nói phía dưới nhé.
- Tiếp theo là câu lệnh CMD. CMD để chỉ câu lệnh **mặc định** khi mà 1 container được khởi tạo từ Image này. CMD sẽ luôn được chạy khi 1 container được khởi tạo từ Image nhé 😉. CMD nhận vào 1 mảng bên trong là các câu lệnh các bạn muốn chạy, cứ 1 dấu cách thì ta viết riêng ra nhé. Ví dụ như: **CMD ["npm", "run", "dev"]** chẳng hạn
  Chú ý là một Dockerfile CHỈ ĐƯỢC CÓ DUY NHẤT 1 CMD. Ô vậy nếu tôi muốn có nhiều CMD thì làm thế nào?? Lát nữa đọc cuối bài nhé 😉

### Build Docker Image

Build docker chạy lệnh sau nhé #docker build

```bash
docker build -t learning-docker/node:v1 .
```

- Để build Docker image ta dùng command **docker build**..
- Option **-t** để chỉ là đặt tên Image là như thế này cho tôi, và sau đó là tên của image. Các bạn có thể không cần đến option này, nhưng như thế build xong ta sẽ nhận được 1 đoạn code đại diện cho image, và chắc là ta sẽ quên nó sau 3 giây. Nên lời khuyên của mình là LUÔN LUÔN dùng option -t này nhé. Phần tên thì các bạn có thể để tuỳ ý. Ở đây mình lấy là **learning-docker/node** và gán cho nó tag là **v1**, ý chỉ đây là phiên bản số 1. Nếu ta không gán tag thì mặc định sẽ được để là **latest** nhé.
- Cuối cùng mình có 1 dấu "chấm" ý bảo là Docker hãy build Image với **context** (bối cảnh) ở folder hiện tại này cho tôi. Và Docker sẽ tìm ở folder hiện tại Dockerfile và build.

Để check danh sách các image có ở máy của bạn

```bash
docker images
# (show tên image, tag, Mã của Image,....)
```

Để xoá image thì các bạn dùng command:

```bash
docker rmi <Mã của Image>
```

### Chạy project từ Docker Image

Để chạy project với `docker-compose`, ta tạo một file mới với tên là `docker-compose.yml`, vẫn ở folder docker-node nhé, với nội dung như sau:

```yml
version: "3.7"

services:
  app:
    image: learning-docker/node:v1
    ports:
      - "3000:3000"
    restart: unless-stopped
```

- Đầu tiên ta định nghĩa `version` của file cấu hình `docker-compose`, lời khuyên là luôn chọn phiên bản mới nhất.
- Tiếp theo là ta có **services**, bên trong **services** ta sẽ định nghĩa tất cả các thành phần cần thiết cho project của bạn, ở đây ta chỉ có 1 service tên là app với image là tên image các ta vừa build
- Ở trong service **app** ta có trường restart ở đây mình để là unless-stopped, ý bảo là tự động chạy service này trong mọi trường hợp (như lúc khởi động lại máy chẳng hạn), nhưng nếu service này bị dừng bằng tay (dừng có chủ đích), hoặc đang chạy mà gặp lỗi bị dừng thì đừng restart nó. Vì khả năng cao khi ta tự dừng có chủ đích là ta muốn làm việc gì đó, hay khi gặp lỗi thì ta cũng muốn tìm hiểu lỗi là gì trước khi khởi động lại
  Cuối cùng là chạy project thôi nào #docker compose run, #docker-compose run

```bash
docker-compose up
```

Ta để ý terminal sẽ thấy như sau:

- Đầu tiên một network mặc định (default) sẽ được tạo ra, và tất cả các services sẽ được join vào chung 1 network này, và chỉ các service ở trong network mới giao tiếp được với nhau. Tên network được mặc định lấy theo tên thư mục.
- Tiếp theo 1 container tên là docker-node_app_1 được tạo ra từ Image của chúng ta. Tên container được tự động chọn để không bị trùng lặp, ta có thể thay đổi tên mặc định này, tuỳ nhu cầu.
- Cuối cùng khi container được chạy thì dòng code **CMD ...** ở cuối file Dockerfile mà ta nói ở phần bên trên sẽ được chạy (các bạn xem lại file Dockerfile nhé).

Sửa xong thì ta quay lại terminal, CTRL+C để terminate docker-compose đi và chạy command sau:

```bash
docker-compose down # dừng các container đang chạy
docker-compose up # khởi động lại
```

### Bên trong Container

Để xem thực sự bên trong container trông như thế nào, mở một terminal khác, các bạn chạy command:

```bash
docker-compose exec app sh
```

Chú ý bên trên **app** là tên của service/container ta muốn xem.
Kiểm tra thông tin hệ điều hành trong container các bạn chạy command sau:

```bash
cat /etc/os-release
```

### Cách chọn bản phân phối thích hợp cho Image

Thì tùy nhu cầu của các bạn mà ta chọn một bản phân phối phù hợp. Nhưng tiêu chí nên là **nhẹ nhất, vừa nhất** (không cần một bản phân phối to đùng, nhiều chức năng trong khi ta chỉ chạy một project bé xíu), và quan trong **bảo mật** phải tốt.

Và lời khuyên của mình là các bạn chọn bản phân phối **Alpine**. Đây là một bản phân phối của Linux rất nhẹ, tối giản và tập trung vào bảo mật cao (Quá tuyệt vời 😄), cùng xem so sánh về size của chúng nhé.
Việc dùng **alpine** giúp ta giảm được size khi build image, build sẽ nhanh hơn nhiều nữa đó

### Build lại Image

Như ở trên mình đã có lời khuyên và từ giờ trở đi trong tất cả các bài sau chúng ta sẽ sử dụng bản phân phối Alpine cho mọi Image chúng ta build nhé, và Alpine cũng sẽ được dùng để chạy Production (chạy thật) luôn nhé.
Bắt tay vào làm thôi nào. Ta quay lại file Dockfile của chúng ta. Ở dòng đầu tiên chính là nơi ta cần quan tâm:

```Dockerfile
FROM node:13-alpine

WORKDIR /app

COPY . .

RUN npm install

CMD ["npm", "start"]
```

Mình khuyên các bạn luôn nói rõ phiên bản của nodejs (hay sau này là php), chứ không dùng **latest**. Vì NodeJS sẽ liên tục được phát triển và cập nhật, nếu ta chỉ để latest thì 1 năm nữa cái **latest** đó có thể đã là phiên bản 20.0, và nhiều hàm/chức năng của NodeJS mà ta sử dụng không còn hoạt động được nữa. Do đó để 10 năm sau code của ta vẫn chạy băng băng thì nên luôn luôn nói rõ phiên bản của Node, PHP, python,... mà chúng ta cần dùng nhé
Tiếp theo ta build lại image nhé. các bạn chạy command sau:

```bash
docker build -t learning-docker/node:v2 .
```

Sau khi build xong Image, ta thử chạy lại project xem chắc chắn mọi thứ vẫn ổn đã nhé. Các bạn sửa lại fie docker-compose.yml phần tên Image sửa thành **v2**. Sau đó ta chạy command sau để khởi động lại project nhé :

```
docker-compose down
docker-compose up
```

Các bạn check thử xem bản phân phối hiện tại có đúng là Alpine không nhé. Chạy command sau:

```bash
docker-compose exec app cat /etc/os-release
```

> Tip: nếu các bạn để ý, để chạy command trong container ta có 2 cách: 1 là "chui" hẳn vào trong container với command "docker-compose exec app sh", 2 là ta ở ngoài và chạy command "docker-compose exec app <do something>" như bên trên mình làm. Dùng cách nào cũng được nhé các bạn

#### Nếu tôi muốn chỉ COPY một hoặc một số file khi build Image

```bash
COPY app.js .  # Copy app.js ở folder hiện tại vào đường dẫn ta set ở WORKDIR trong Image
COPY app.js /abc/app.js   ## Kết quả tương tự, ở đây ta nói rõ ràng hơn (nếu ta muốn copy tới một chỗ nào khác không phải WORKDIR)

# Copy nhiều file
COPY app.js package.json package-lock.json .
# Ở trên ta các bạn có thể copy bao nhiêu file cũng được, phần tử cuối cùng (dấu "chấm") là đích ta muốn copy tới trong Image
```

#### Mỗi file Dockerfile chỉ cho phép có 1 CMD, vậy nếu tôi muốn có nhiều CMD thì sao?

Thì hiện tại Docker chỉ cho phép chạy 1 `CMD` khi khởi động container, nhưng nếu `CMD` của các bạn phức tạp thì ta có thể dùng tới `ENTRYPOINT`

ENTRYPOINT, có thể hiểu theo nghĩa đen là "điểm bắt đầu", nó có thể chạy khá giống như `CMD` nhưng cũng có thể dùng để cấu hình cho `CMD` trước khi ta chạy `CMD`. Một trường hợp thường dùng với `ENTRYPOINT` là ta dùng 1 file shell script `.sh` để cấu hình tất tần tật những thứ cần thiết trước khi khởi chạy container bằng `CMD`

```Dockerfile
....
ENTRYPOINT ["sh", "/var/www/html/.docker/docker-entrypoint.sh"]

CMD supervisord -n -c /etc/supervisord.conf
```

#### Tôi muốn chạy docker-compose ở background?

```bash
docker-compose up -d     # thêm option -d nhé
```

Để check log khi project đang chạy các bạn có thể dùng command sau:

```
docker-compose logs    # check log ở thời điểm command chạy
docker-compose logs -f     # check log realtime
```