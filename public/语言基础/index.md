# Common Knowledge


<!--more-->

- 什么是死锁?
  线程 a 和线程 b 互相持有对方想要的资源, 双方都在等待对方释放资源, 僵持不下;
  操作一个对象, 必须需要对象锁, 如果线程 a 拥有资源 A 的 🔓, 线程 b 拥有资源 B 的 🔓, 当同时, 线程 a 和线程 b 想要操作被对方占用了对象 🔓 的资源, 就必须等待对方, 到天长地久...

- 什么是乐观锁? 什么是悲观 🔓?
  乐观锁: 每次拿到数据之后不会上锁, 但是会在更新的时候根据版本号的区别, 判断以下别人有没有更新这个数据; 数据的更新都是有版本号标记的, 如果一个数据被两个线程更新, 线程 a 拿到的时候, 版本号是 1, 它对数据进行操作后, 版本号+1, 成为 2, 线程 b 拿到的时候, 版本号是 2, 它对数据进行操作后, 版本号+1, 还是 2, 那么线程 b 的操作就会被舍弃...
  悲观锁: 每次拿到数据之后都会上锁(对共享资源上锁), 这样被人想要拿数据的时候就必须等待, 直到他用完资源, 把锁空出来;

- Go 中的多态和继承?

  **多态:** 父类 Animal 和子类: Dog, 两者共同拥有一个方法, run(), 如果有一个函数可以接收这个 Animal, 那么就可以接收 Dog, 这时它运行传入对象的 run 方法, 可能调用 Animal 的 run 方法, 也可能调用 Dog 的 run 方法, 这个就叫做多态;

  Go 中多态的实现依赖 interface, 如果两个类都实现了 run 方法, 那么它们就实现了这个接口, 传入这个接口的函数就可以接收传入这两个类;

  **继承:** Go 中, 一个类要使用其他类的方法 _组合_

  Go 中的组合:

  ```go
  type Person struct {
      Name string
      Age  int
  }
  func (p *Person) Laugh() {
      log.Println("Hahahahaha :)")
  }
  // 如果Person和Children都有Laugh(), 那么c.Laugh() 会优先使用Child的Laugh
  // 如果Children想要拿到Person的属性: Field, 那么就使用c.Person.Field
  type Children struct {
      *Person
      Height int
  }
  func main() {
      c := Children{&{Name: "leo2n", Age: 26}, 180}
      c.Langh()
  }
  ```

