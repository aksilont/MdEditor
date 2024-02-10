# Spy
**Spy** — это более функциональная версия **Stub**, а его главной задачей является наблюдение и запись данных и/или вызовов во время исполнения теста. **Spy** используется для дальнейшей проверки корректности вызова зависимого объекта. Позволяет проверить логику именно тестируемого объекта без проверки зависимых объектов.

Так что во многих отношениях **Spy** — это просто **Stub** с возможностью записи. Хотя он используется для той же фундаментальной цели, что и **Mock**, стиль теста, который мы пишем с помощью **Spy**, больше похож на тест, написанный с помощью **Stub**.

```swift
class TestClass {
 public summ(arg1: number, arg2: number): number {
   return arg1 + arg2;
 }
 
 public callAnotherFN(arg1: number, arg2: number): number {
   const result = this.summ(arg1, arg2);
   return result;
 }
}
 
const instance = new TestClass();
 
it('should call spied function', () => {
 jest.spyOn(instance, 'summ');
 instance.callAnotherFN(1, 2);
 expect(instance.summ).toHaveBeenCalled();
});
```

В этом юнит-тесте мы проверяем, что метод callAnotherFN() вызывает метод summ(). Нам важен не результат выполнения, а лишь факт вызова.