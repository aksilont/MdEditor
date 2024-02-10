# Dummy Object
Чаще всего методы класса или функции нуждаются в каких-то параметрах, но не всегда эти параметры могут быть важны для теста. В таких ситуациях следует использовать **Dummy**.

По сути — это объект, который передается в метод, но на самом деле не используется, не производит никаких изменений, не вызывает другие методы и не имеет никакого поведения.

Такой объект нужен просто для того, чтобы тест прошел. Очень часто это просто NULL или пустой объект. **Dummy** не является как таковым test double, но рассматривая тему «Doubles в Unit tests» его нельзя не упомянуть.

```swift
class TestClass {
 public logger(message: string): void {
   console.log(message);
 }
 
 public callAnotherFN(value: string): string {
   this.logger(value);
   return value;
 }
}
 
const instance = new TestClass();
 
it('should call function with Dummy Object', () => {
 jest.spyOn(instance, 'logger');
 const result = instance.callAnotherFN(null);
 expect(instance.logger).toHaveBeenCalled();
 expect(result).toBe(null);
});
```

В данном юнит-тесте нам важно проверить работу функции и то, что она вызывает внутри себя другую. Нам не важен результат ее выполнения, поэтому в качестве **Dummy** здесь используется null.