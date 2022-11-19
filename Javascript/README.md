<!-- @format -->

# Java script nâng cao

- [Back](../README.md)



#### Closure
Là một hàm có thể ghi nhớ nơi nó được tạo ra và truy cập được biến ở bên ngoài phạm vi của nó.
###### Ứng dụng
- Viết code ngắn gọn hơn.
- Biểu diễn, ứng dụng tính private trong OOP

###### Lưu ý
- Biến được tham chiếu(refer) trong clouse sẽ không được xóa hỏi bộ nhớ khi hàm cha thực thi xong.

##### Ví dụ
save() dưới đây sẽ là 1 hàm closure

```javascript
function createStorage(key) {
  const storage = JSON.parse(localStorage.getItem(key)) ?? {}

  const save = () => {
    localStorage.setItem(key, JSON.stringify(store))
  }

  const storage = {
    get(key){return storage},
    set(key, value){
      store[key] = value
      save()
    },
    remove(key){
      delete store[key]
      save()
    }
  }

return storage;
}

const profileSetting = createStorage('profile_setting')
profileSetting.set('fullName', 'Midne')

```


```javascript
function createApp() {
  const cars = []

  return {
    add(car){
      cars.push(car)
    },
    show(){
      console.log(cars)
    }
  }
}

const app = createApp()
app.add('BMV')
app.show()
```


#### Hoisting
Đưa các khai báo với biến var và khi báo các hàm lên đầu phạm vi được khai báo.

###### Hoisting với var và function declaration
```
console.log(age) // undefined
console.log(name) // name is not defined

var age = 22;
```

#### "use strict" hay strict mode
