# 6. 객체와 자료 구조

변수를 비공개(private)로 정의하는 이유
* 남들이 변수에 의존하지 않게 만들고 싶어서
* 변수 타입이나 구현을 맘대로 바꾸고 싶어서

## 자료 추상화

목록 6-1 구체적인 Point 클래스
```java
public class Point {
	public double x;
	public double y;
}
```

목록 6-2 추상적인 Point 클래스
```java
public interface Point {
	double getX();
	double getY();
	void setCartesian(double x, double y);
	double getR();
	double getTheta();
	void setPolar(double r, double theta)
}
```

||목록 6-1|목록6-2|
|---|---|---|
|구현|외부로 노출|완전히 숨김|
|좌표계(구현방식)|직교좌표계|알 수 없음|
|접근정책|개별적으로 좌표값 읽고 설정|읽을때는 개별적, 설정할때는 한꺼번에|

* 변수를 private으로 설정하더라도 각 값마다 getter, setter 함수를 제공하면 구현을 외부로 노출 : 변수 사이에 함수라는 계층을 넣는다고 구현이 감춰지는 것이 아님
* 구현을 감추려면 추상화가 필요 : 추상 인터페이스를 제공해 사용자가 구현을 모른 채 자료의 핵심을 조작할 수 있어야 진정한 의미의 클래스

목록 6-3 구체적인 Vehicle 클래스
```java
public interface Vehicle {
	double getFuelTankCapacityInGallons();
	double getGallonsOfGasoline();
}
```

목록 6-4 추상적인 Vehicle 클래스
```java
public interface Vehicle {
	double getPercentFuelRemaining();
}
```

||목록6-3|목록6-4|
|---|---|---|
|자동차 연료 상태|구체적인 숫자 값|백분율이라는 추상적인 개념|
|함수가 반환하는 정보|변수값을 읽어 반환하는 것이 확실|정보가 어디서오는지 알 수 없음|

* 인터페이스나 getter, setter 만으로 추상화가 이루어지지 않는다. 객체가 포함하는 자료를 표현할 가장 좋은 방법을 심각하게 고민해야함

## 자료/객체 비대칭
* 객체 : 추상화 뒤로 자료를 숨긴 채 자료를 다루는 함수만 공개
* 자료구조 : 자료를 그대로 공개하며 별다른 함수를 제공하지 않음

목록 6-5 절차적인 도형
```java
public class Square {
	public Point topLeft;
	public double side;
}

public class Rectangle {
	public Point topLeft;
	public double height;
	public double width;
}

public class Circle {
	public Point center;
	public double radius;
}

public class Geometry {
	public final double PI = 3.141592653589793;
	
	public double area(Object shape) throws NoSuchShapeException {
		if (shape instanceof Square) {
			Square s = (Square)shape;
			return s.side * s.side;
		} else if (shape instanceof Rectangle) {
			Rectangle r = (Rectancle)shape;
			return r.height * r.width;
		} else if (shape instanceof Circle) {
			Circle c = (Circle)shape;
			return PI * c.radius * c.radius;
		}
		throw new NoSuchShapeException();
	}
}
```

* 새 기능(함수)를 추가하려면 : 도형 클래스는 아무 영향이 없음
* 새 도형(변수)을 추가하려면 : Geometry 클래스에 속한 함수 모두 수정 필요

목록 6-6 다형적인 도형
```java
public class Square implements Shape {
	private Point topLeft;
	private double side;
	
	public double area() {
		return side*side;
	}
}

public class Rectangle implements Shape {
	private Point topLeft;
	private double height;
	private double width;
	
	public double area() {
		return height * width;
	}
}

public class Circle implements Shape {
	private Point center;
	private double radius;
	public final double PI = 3.141592653589793;
	
	public double area() {
		return PI * radius * radius;
	}
}
```

* area()는 다형(polymorphic) 메서드
* 새 도형을 추가해도 기존 함수에 아무런 영향을 미치지 않는다.
* 새 함수를 추가하고 싶으면 도형 클래스 전부를 고쳐야 한다.

객체와 자료 구조는 근본적으로 양분된다.
* 절차지향 코드 : 기존 자료 구조를 변경하지 않으면서 새 함수를 추가하기 쉬움, 새로운 자료구조를 추가하려면 모든 함수 수정 필요
* 객체지향 코드 : 기존 함수를 변경하지 않으면서 새 클래스를 추가하기 쉬움 : 새로운 함수를 추가하려면 모든 클래스 수정 필요
* 적합한 상황이 다름

## 디미터 법칙
클래스 C의 메서드 f는 다음과 같은 객체의 메서드만 호출해야 한다.
(모듈은 자신이 조작하는 객체의 속사정을 몰라야 한다.)

* 클래스 C
* f가 생성한 객체
* f 인수로 넘어온 객체
* C 인스턴스 변수에 저장된 객체

아래 코드는 위 규칙 위배할까?(f가 반환된 객체의 메서드를 호출)

1. **기차 충돌**(조잡하다)
```java
final String outputDir = ctxt.getOptions().getScratchDir().getAbsolutePath();`
```

2. 아래와 같이 개선 가능
```java
Options opts = ctxt.getOptions();
Final scratchDir = opts.getScratchDir();
final String outputDir = scratchDir.getAbsolutePath();
```

위 코드를 호출하는 함수는 ctxt가 Options를 포함하고, Options가 ScratchDir을 포함하며, ScratchDir이 AbsolutePath를 포함한다는 사실을 안다.(많은 객체를 탐색) ctxt, Options, ScratchDir이 객체라면 디미터 법칙 위반, 자료구조라면 디미터 법칙이 적용되지 않음

아래 처럼 구현하면 오해의 소지가 없다(ctxt. Options, ScratchDir 모두 자료 구조)

`final String outputDir = ctxt.options.scratchDir.absolutePath`

* 자료 구조는 무조건 함수 없이 공개 변수만 포함하고, 객체는 비공개 변수와 공개 함수를 포함하면 오해가 없것이나, 단순한 자료 구조에도 getter, setter를 요구하는 프레임워크와 표준이 존재한다.
* **잡종 구조** : 절반은 객체, 절반은 자료구조 : 새로운 함수, 새로운 자료 구조 모두 추가하기 어려운 단점만 모아놓은 구조(어중간한 설계)
* **구조체 감추기** : 객체에 위임(위 사례에서는 outputDir을 직접 얻으려 하지 않고, 사용하기 위한 목적인 임시 파일 생성을 ctxt에 위임 할 수 있다.

  `BuffuredOutputStream bos = ctxt.createScratchFileStream(classFileName)`)

## 자료 전달 객체(Data Transfer Object)

* DTO는 데이터베이스에 저장된 가공되지 않은 정보를 애플리케이션 코드에서 사용할 객체로 변환하는 일련의 단계에서 처음으로 사용하는 구조체
* bean : DTO의 일반적인 구조로 private 변수를 getter/setter 함수로 조작(사이비 캡슐화)
* **활성 레코드(Active Record)** : DTO의 특수한 형태
  * 데이터베이스 테이블이나 다른 소스에서 자료를 직접 변환한 결과
  * 자료 구조에 save나 find 같은 탐색 함수도 제공
  * 비즈니스 규칙 메서드가 추가되면 잡종 구조가 됨 -> 자료 구조로 취급하여 비즈니스 규칙을 담으면서 내부 자료를 숨기는 객체는 따로 생성