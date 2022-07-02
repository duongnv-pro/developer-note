<!-- @format -->

# Docker Tutorial

- [Back](../README.md)

## Dockerize ứng dụng VueJS, ReactJS

> https://viblo.asia/p/dockerize-ung-dung-vuejs-reactjs-ORNZqxwNK0n
### Dockerize Project VueJS
#### Cấu hình Dockerfile
Ở folder **docker-vue** các bạn tạo file tên là `Dockerfile` với nội dung như sau:
```Dockerfile
# build stage
FROM node:13-alpine as build-stage
WORKDIR /app
COPY . .
RUN npm install  ## các bạn có thể dùng yarn install .... tuỳ nhu cầu nhé
RUN npm run build

# production stage
FROM nginx:1.17-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
```
Đối với project Vue hoặc React là dạng full frontend, không có tí backend nào, chúng chỉ được chạy trên trình duyệt. Mà khi ra tới trình duyệt, thì thứ trình duyệt hiểu chỉ là HTML, CSS, JS.
Do đó để Dockerize ứng dụng Vue/React việc của ta là chỉ cần lấy được những file build cuối cùng cần thiết để chạy ở trình duyệt còn những thứ khác có hay không có, không quan trọng 😄, làm như thế thì Image của chúng ta sẽ giảm được size xuống, giảm thiểu tối đa những thứ không cần thiết bên trong Image.
- Ở file Dockerfile chúng ta chia làm 2 stage (giai đoạn) khi build image: **build stage** và **production stage**
- Ở **build stage** ta bắt đầu từ image tên là **node:13-alpine**. Để đặt tên cho từng giai đoạn ta dùng từ khoá **as**
- Trong build stage ta bắt đầu từ đường dẫn **/app**, sau đó copy toàn bộ file ở folder hiện tại ở môi trường ngoài, tức folder **docker-vue** vào bên trong đường dẫn ta set ở WORKDIR tức **/**app bên trong image.
- Tiếp theo ta chạy **npm install** như thường lệ để cài dependencies và cuối cùng là build project
- Ok build xong giờ tiến tới **production stage**: nơi ta định nghĩa cách chạy project
Ở production stage ta bắt đầu với image tên là **nginx**.... đặt tên stage này là production-stage với từ khoá **as**
- Thế **nginx** ở đây là cái gì thế ???? Project VueJS hay ReactJS khi chạy sẽ cần một webserver để có thể chạy được nó, và Nginx ở đây chính là webserver. Ở local có cần Nginx gì đâu nhỉ? Vì ở local khi chạy **npm run dev** thì các nhà phát triển VueJS đã thiết lập sẵn cho chúng ta 1 local webserver rồi nhé, nhưng khi chạy thật thì không nên dùng nhé, phải có 1 webserver xịn, và Nginx thì rất là xịn nhé 😄 😄
- Sau đó, phần này quan trọng nè, ta COPY từ **build-stage** lấy folder ở đường dẫn **app/dist** chính là "những file build cuối cùng cần thiết để chạy ở trình duyệt", ta lấy folder đó và copy vào đường dẫn **/usr/share/nginx/html**, đây chính là nơi Nginx sẽ tìm tới và trả về cho user khi user truy cập ở trình duyệt
- Và cuối cùng ta có CMD khởi động Nginx
#### Build Image
Và để build image thì vẫn như một cái thường lệ từ các bài trước 😄, ta chạy command sau:
```bash
docker build -t learning-docker/vue:v1 .
```
#### Chạy project
Để chạy project ta lại "rất như thường lệ các bài trước" lại tại một file tên là **docker-compose.yml** với nội dung như sau:
```yml
version: "3.8"

services:
  app:
    image: learning-docker/vue:v1
    ports:
      - "5000:80"
    restart: unless-stopped
```
```bash
docker-compose up
```
### Dockerize project ReactJS
Với project ReactJS thì sự giống nhau là 96,69% so với VueJS nhé, điều duy nhất khác biệt đó là React khi build sinh ra project tên là **build** chứ không phải **dist** như Vue, nên file Dockerfile nom sẽ như sau nhé:
```Dockerfile
# build stage
FROM node:13-alpine as build-stage
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
# production stage
FROM nginx:1.17-alpine as production-stage
COPY --from=build-stage /app/build usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
```
### Có cách nào để không phải chia Dockerfile thành 2 stage?
Thì câu trả lời là có, về sau khi mình hiểu được cách này thì mình toàn dùng cách này cả 😄.
Trước hết ta sẽ cần lắc não một chút:

- Như ở trên mục đích của chúng ta là cần phải build được project, sau đó lấy "những file build cuối cùng" tức là lấy được folder **dist** ở Vue hoặc **build** ở bên React và gửi nó tới Nginx và bảo "Nginx cậu show hàng hộ tớ nếu có user hỏi thăm đến tớ" 😂😂
- Vậy vấn đề ở đây là làm cách nào có thể build được project mà không cần dùng thêm một stage như ở Dockfile, sau đó chuyển nó tới cho anh bạn thân Nginx là ok rồi 😉
#### Setup
Docker hỗ trợ chúng ta có thể tạo ra một "container tạm thời" (intermediate container, từ này dịch ra phải là trung gian mới đúng như nghe nó không hay 😄).

Container này sau khi làm xong nhiệm vụ thì sẽ tự được xoá đi.

Ta sẽ dùng container này để build project nhé 😉

Vẫn ở folder **docker-vue** chạy command sau:
```bash
docker run --rm -v $(pwd):/app -w /app node:13-alpine npm install && npm run build
```
Giải thích:
- Ở câu lệnh trên ta chạy câu lệnh docker tạo ra 1 container với option **--rm** ý bảo "chạy xong chú tự xoá đi nhé"
- Tiếp theo ta có option **-v** tức là **volume**, ồ volume là gì mới à nha. Ở bài đầu tiên mình đã nói tới rồi nhé, các bạn cứ bình tĩnh dần dần ta sẽ học nó nhiều hơn
- Sau **-v** là `$(pwd):/app`, ở đây ý ta bảo là đưa toàn bộ file ở folder hiện tại ở môi trường gốc ánh xạ vào trong đường dẫn /app trong Image ( `$(pwd)` trả về đường dẫn hiện tại) , việc này gọi đúng thuật ngữ thì là **mount**
- Tiếp theo ta có option **-w** chính là WORKDIR nhé
- Tiếp theo ta có **node:13-alpine**: tương đương với FROM:node:13-alpine
- Sau đó là các command ta cần chạy để build project.
Các bạn chạy command trên nhé, có thể 1 lúc không thấy terminal in ra gì, đừng hoang mang nhé, 1 chút thôi là in ra cả một đống log đó 😄

Sau khi command trên chạy thành công thì các bạn sẽ thấy ở folder **docker-vue** xuất hiện cả folder **node_modules** và folder **dist**. Đây chính là điều mà **volume** trong Docker mang lại.

Volume giúp ánh xạ file ở môi trường ngoài vào trong Docker container, và ánh xạ này là ánh xạ 2 chiều, ngoài thay đổi thì trong thay đổi, trong thay đổi thì ngoài thay đổi theo. Đó là lí do vì sao khi command trên chạy xong ở bên ngoài ta lại có kết quả như vậy. Dần dần các bạn sẽ hiểu volume nó là gì nhé 😉
Ok vậy là giờ ta đã có folder dist rồi, nhiệm vụ tiếp theo là gửi nó tới nginx.
Các bạn sửa lại file **docker-compose.yml** như sau:
```yml
version: "3.4"

services:
  app:
    image: nginx:1.17-alpine
    volumes:
      - ./dist:/usr/share/nginx/html
    ports:
      - "5000:80"
    restart: unless-stopped
```
Ở trên ta đã thay tên image bằng tên của image của Nginx, đồng thời ta dùng từ khoá **volumes** để ánh xạ nội dung **bên trong** folder **dist** vào trong folder **/usr/share/nginx/html** nơi Nginx cần. (nhớ là nội dung bên trong **dist** chứ không có folder dist đâu nhé)
Các bạn chú ý trong docker khi ta ánh xạ (hay gọi chính xác là **mapping** dùng cho port hay **mount** dùng cho volume), biêủ thức sẽ chia làm 2 vế thì vế trái luôn là ở môi trường gốc (bên ngoài), vế phải là bên trong container nhé

Và chú ý là khi ánh xạ volumes thì vế bên phải (nơi container) đường dẫn phải là **đường dẫn tuyệt đối** nhé.
Cuối cùng là ta chạy lại project xem sao nào:
```bash
docker-compose up
```
Ta thử chui vào container xem có gì nhé, các bạn mở terminal khác tại folder docker-vue và chạy command sau:
```bash
docker-compose exec app sh
cd /usr/share/nginx/html
ls -l
```

Khi dev thì bạn chạy cho mình command sau mỗi lúc dev nhé:
```bash
docker run --rm -v $(pwd):/app -w /app node npm run watch
```
Giải thích: tạo ra 1 container tạm thời, dùng image node, mount volume ở đường dẫn hiện tại của máy gốc ($pwd) vào đường dẫn /app trong container và chạy watch.

#### Review
Tại sao với Vue hay React mình lại chọn cách này??

Các bạn để ý thấy là cuối cùng ở file **docker-compose** khi chạy ta dùng image **nginx** là image đã được build sẵn, chứ không còn dùng image **learning-docker:vue** nữa. Mà image **learning-docker:vue** cần phải build mới có thể dùng được. Do đó mỗi khi code Vue của ta thay đổi thì ta cần build lại Image. Tức là ta không cần dùng đến file Dockerfile nữa 😉

Còn bây giờ dùng cách này ta không cần build lại image nữa. Chạy **npm install** thì hiển nhiên dù có hay không có Docker ta vẫn phải chạy để cài dependencies rồi, chạy **npm run build** thì cũng là hiển nhiên phải chạy để build project dù có hay không có Docker rồi. Điều khác biệt chút chút là giờ ta chạy nó với command:
```bash
docker run --rm -v $(pwd):/app -w /app node:13-alpine npm install && npm run build
```
KHÔNGGGGGGG 😭😭, dùng cách này tự nhiên ở môi trường gốc bên ngoài của tôi lại có **node_modules** và **dist** nó làm môi trường gốc của tôi không còn "trinh trắng" nữa. Cái gì bên trong Docker thì hay cứ ở bên trong đó đi...
Nếu việc ta **mount** từ folder bên ngoài vào trong container làm bên ngoài xuất hiện thêm nhiều file làm các bạn thấy không muốn thì các bạn có thể quay lại cách build Image với 2 stages như đầu bài ta đã làm.
### Lúc nào cũng dùng cách này có được không?
Thì cách này theo mình thấy dùng được cho các project khi chạy hoặc build không cần cấu hình nhiều, các project chuyên về frontend, không dính dáng tí backend nào, kiểu react, vue, angular, ember,... đều chơi được

Còn các project có backend thì thường ta sẽ cần setup nhiều bước và nhiều thứ lằng nhằng nên cách này sẽ khó đáp ứng được
### Thay đổi code bên ngoài F5 trình duyệt không thấy thay đổi????
Thế vậy map volume toàn bộ code từ bên ngoài vào là được đúng không............. 😉 Khồnggggg, nếu ta chỉ map code từ bên ngoài vào thì khi ta thay đổi, code bên trong container cũng thay đổi, nhưng chúng không được build lại. Chúng ta phải làm sao chạy được npm run serve để nó lắng nghe code thay đổi và build lại bất kì khi nào ta đổi code. Các bạn làm như sau nhé.
Ở Dockerfile các bạn sửa lại như sau:
```dockerfile
FROM node:12.18-alpine
WORKDIR /app
COPY . .
RUN npm install
CMD ["npm", "run", "serve"]
```
Ở đây ta đã bỏ đi chỉ còn 1 chút tí tẹo, để chạy **npm install** và chạy **npm run serve** để theo dõi code thay đổi và tự động build lại nhé.
Tiếp theo ta build lại image nhé:
```bash
docker build -t learning-docker/vue:v1 .
```
Tiếp đó ở `docker-compose.yml` các bạn sửa lại như sau:
```yml
version: "3.4"

services:
  app:
    image: learning-docker/vue:v1
    volumes:
      - ./src:/app/src
    ports:
      - "5000:8080"
    restart: unless-stopped
```
Vì `npm run serve` đã tạo sẵn một server dev ở cổng `8080` nên đó là lí do vì sao ta không cần tới `nginx` làm webserver nữa, và như các bạn có thể thấy giờ ta map vào container port `8080` chứ không phải `80` như với `nginx` nữa.
Cùng với đó các bạn thấy là ta mount volume chỉ mỗi folder src vào trong. Tại sao ta không mount tất cả như sau:
```yml
volumes:
      - ./:/app/
```
Tại saooooooooooooooooooooooooooo? 😤😤
Lí do nếu ta mount toàn bộ folder bên ngoài vào trong thì vì bên ngoài không có `node_modules` (bên ngoài ta vẫn còn trinh 😄 ), nên tại thời điểm chạy, toàn bộ bên ngoài sẽ overridde bên trong dẫn tới bên trong mất `node_modules`, vậy nên ta chỉ map cụ thể những folder cần thiết vào trong.