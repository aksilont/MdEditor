# Stub
В переводе с английского stub означает «заглушка». Такой перевод довольно ярко отображает принцип работы **Stub**, ведь это объект, содержащий предопределенные данные, которые он использует для ответа на вызовы во время тестов.

Он используется, когда мы не можем или не хотим задействовать объекты, которые будут отвечать реальными данными или иметь нежелательные побочные эффекты.

Вместо реального объекта мы используем **Stub** и определяем для него данные, которые нужно возвращать.

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
 
it('should return stubbed value', () => {
 instance.summ = jest.fn().mockReturnValue(100);
 const result = instance.callAnotherFN(1, 2); // 3
 expect(result).toBe(100);
});
```

В данном примере мы тестируем метод callAnotherFN(). Нам важно убедиться, что он корректно отрабатывает, то есть возвращает значение вызова другого метода. Поскольку в этом тесте нас не интересует корректность работы метода summ(), мы используем **Test stub**.