# 4장 주석

좋은 주석은 유용하지만, 좋지 않은 주석은 코드를 이해하기 어렵게 만들고, 잘못된 정보를 제공한다. 코드는 변하고 진화하는데, 주석이 항상 변화를 따라가기는 어렵다. 코드만이 정확한 정보를 제공한 유일한 출처이기 때문에, 주석 대신 코드로 의도를 표현하려고 해야한다.

## 주석은 나쁜 코드를 보환하지 못한다.

코드에 주석을 추가하는 일반적인 이유는 코드 품질이 나쁘기 때문이다. 코드를 정리해서 표현력이 풍부하고 깔끔한 코드로 주석을 대신하자

## 코드로 의도를 표현하라!

고민하여 의도를 주석 대신 코드로 표현하자. 많은 경우 주석으로 달려는 설명을 함수로 만들어 표현해도 충분하다.

```java
// 직원에게 복지 혜택을 받을 자격이 있는지 검사한다.
if ((employee.flags & HOURLY_FLAG) &&
	(employee.age > 65))
```
*위 코드의 주석을 함수로 만들어 코드로 표현*
```java
if (employee.isEligibleForFullBenefits())
```

## 좋은 주석

* **법적인 주석** : 회사가 정립한 구현 표준에 맞춰 법적인 이유로 특정 주석을 넣으라고 명시(ex. 저작관 정보, 소유권 정보). 모든 조항, 조건을 열거하는 대신 가능하면 표준 라이선스나 외부 문서 참조
* **정보를 제공하는 주석** : 기본적인 정보를 주석으로 제공하면 편리. 가능하면 함수 이름에 정보를 담아 주석을 제거하거나 클래스를 만들어 코드로 표현
* **의도를 설명하는 주석** : 구현을 이해하는 정도를 넘어 결정에 깔린 의도를 설명
* **의미를 명료하게 밝히는 주석** : 표준 라이브러리나 변형하지 못하는 코드로 인수나 반환값의 의미가 모호하게 표현될수 밖에 없는 경우(ex. `a.compareTo(b) == -1 // a < b`). 올바른지는 검증 불가 
* **결과를 경고하는 주석** : 다른 프로그래머에게 결과 경고 목적(ex. junit4의 @ignore 속성이 존재하기 전, 오래 걸리는 테스트 케이스를 실행할지 판단하라고 경고하는 주석이나 스레드 안전 문제로 정적 초기화 함수 대신 인스턴스를 독립적으로 생성하라고 경고하는 주석)
* **TODO 주석** : 앞으로 할일과 현재 구현하지 않은 이유와 미래 모습 명시. 주기적으로 없애도 괜찮은지 점검 필요
* **중요성을 강조하는 주석** : 대수롭지 않다고 여겨질 무언가의 중요성을 강조(tip?)
* **공개 API에서 Javadocs** : 설명이 잘 된 공개 API나 표준 자바 라이브러리에서 사용한 Javadocs. 여느 주석과 마찬가지로 독자를 오도하거나, 잘못 위치하거나 그릇될 정보를 전달한 가능성 존재

## 나쁜 주석

* **주절거리는 주석** : 저자가 서둘렀거나 부주의하여 주절거려 놓아서 이해가 안되어 다른 모듈까지 참조해야하는 주석은 독자와 제대로 소통하지 못하는 주석. 주석을 달기로 결정했다면 충분한 시간을 들여 최고의 주석 작성 노력 필요
* **같은 이야기를 중복하는 주석** : 코드보다 더 많은 정보를 제공하지 못하고 같은 내용의 코드를 그대로 중복하는 코드. 실제 코드보다 부정확해 함수를 대충 이해하고 넘어가게 만들기도 한다.
* **오해할 여지가 있는 주석** : 코드와 딱 맞을 정도로 엄밀하게 주석을 달지 못해, (코드보다 읽기도 어려운) 주석에 담긴 '살짝 잘못된 정보'로 다른 프로그래머가 오해

  *중복이 많으면서도 오해할 여지가 있는 주석*
   ```java
   // this.closed가 true일 때 반환되는 유틸리티 메서드다.
   // 타임아웃에 도달하면 예외를 던진다.
   public synchronized void waitForClose(final long timeoutMills) throws Exception {
   	if(!closed) {
   		wait(timeoutMills);
   		if(!closed)
   			throw new Exception("MockResponseSender could not be closed");
   	}
   }
   ```

* **의무적으로 다는 주석** : 모든 함수에 Javadocs를 달거나 모든 변수에 주석을 달아야 한다는 규칙으로 의미 없이 다는 주석. 아무런 가치도 없고, 코드를 복잡하게 만들며 혼동과 무질서 초래(+잘못된 정보 제공 여지 존재)
* **이력을 기록하는 주석** : 과거의 관례로 현재는 소스 코드 관리 시스템을 사용하고 완전히 제거하라.
* **있으나 마나 한 주석** : 너무 당연한 사실을 언급하여 새로운 정보를 제공하지 않거나(개발자가 주석을 무시하는 습관 초래), 분풀이 주석. 분풀이 대신 코드 구조를 개선하도록 노력
* **무서운 잡음** : Javadocs 처럼 문서를 제공해야한다는 잘못된 욕심(복사 붙여넣기 오류 발생 가능)
* **함수나 변수로 표현할 수 있다면 주석을 달지 마라** : 주석이 필요하지 않도록 코드를 개선
  ```java
  // 전역 목록 <smodule>에 속하는 모듈이 우리가 속한 하위 시스템에 의존하는가?
  if (smodule.getDependSubSystems().contains(subSysMod.getSubSystem()))
  ```
  *위 코드는 아래와 같이 표현 가능*
  ```java
  ArrayList moduleDependees = smodule.getDependSubSystems();
  String ourSubSystem = subSysMod.getSubSystem();
  if (moduleDependees.contains(ourSubSystem))
  ```
* **위치를 표시하는 주석** : 소스 파일에서 특정 위치를 표시(배너). 너무 자주 사용하지 않으면 눈에 띄며 주의를 환기할 수 있지만, 남용하면 잡음으로 여겨 무시하게 된다.
* **닫는 괄호에 다는 주석** : 중첩이 심하고 장황한 함수에서 의미가 있을 수 있으나, 차라리 대신 작고 캡슐화된 함수를 만들어 함수를 줄이려 시도하는 것이 좋다.
* **공로를 돌리거나 저자를 표시하는 주석** : 이제는 소스 코드 관리 시스템 사용
* **주석으로 처리한 코드** : 중요할 수 있어 참고용으로 지우지 않는 목적이라면 이제는 소스 코드 관리 시스템 사용
* **HTML 주석** : 도구로 뽑아 웹페이지에 올릴 목적이라면 도구로 개선(주석에서 HTML이 섞여있으면 읽기 어렵다)
* **전역 정보** : 근처에 있는 코드가 아니면 통제할 수 없다.(ex. 전역 정보 주석에 어딘가에 있는 함수 설명)
* **너무 많은 정보** : 역사나 관련없는 정보 대신 핵심 내용이나 참조할 수 있는 번호(RFC 번호 등)만 작성
* **모호한 관계** : 주석과 주석이 설명하는 코드의 관계가 모호한 경우. 주석 자체가 다시 설명을 요구하는 경우
* **함수 헤더** : 짧고 한가지만 수행하며 이름을 잘 붙인 함수는 긴 설명이 필요 없다.
* **비공개 코드에서 Javadocs** : 공개하지 않을 코드(시스템 내부에 속한 클래스와 함수)라면 Javadocs가 요구하는 형식으로 코드만 보기 싫고 산만해진다.
* 예제
  ```java
  /**
   * 이 클래스는 사용자가 지정한 최대 값까지 소수를 생성한다. 사용한 알고리즘은 
   * 에라스토테네스의 체다.
   * <p>
   * 에라스토테네스: 기원전 276년에 리비아 키레네에서 출생, 기원전 194년에 사망
   * 지구 둘레를 최초로 계산한 사람이자 달력에 윤년을 도입한 사람.
   * 알렉산드리아 도서관장을 역임
   * </p>
   * 알고리즘은 상당히 단순하다. 2에서 시작하는 정수 배열을 대상
   * 으로 2의 배수를 모두 제거한다. 다음으로 남은 정수를 찾아 이 정수의 배수를 모두 지운다.
   * 최대 값의 제곱근이 될 때까지 이를 반복한다.
   *
   * @author Alphonse
   * @version 13 Feb 2002 atp
   */
   import java.util.*;
   
   public class GeneratePrimes {
  	/*
  	 * @param maxValue는 소수르 찾아낼 최대 값
  	 */
  	 public static int[] generatePrimes(int maxValue) {
  		 if (maxValue >= 2) {  // 유일하게 유요한 경우
  			 // 선언
  			 int s = maxValue + 1;  // 배열 크기
  			 boolean[] f = new booleans[s];
  			 int i;
  			 
  			 // 배열을 참으로 초기화
  			 for (i = 0; i < s; i++)
  				 f[i] = true;
  			 
  			 // 소수가 아닌 알려진 숫자를 제거
  			 f[0] = f[1] = false;
  			 
  			 // 체
  			 int j;
  			 for (i = 2; i < Math.sqrt(s) + 1; i++) {
  				 if (f[i]) {  // i가 남아 있는 숫자라면 이 숫자의 배수를 구한다.
  					 for (j = 2 * i; j < s; j += i)
  						 f[j] = false;  // 배수는 소수가 아니다.
  				 }
  			 }
  			 
  			 // 소수 개수는?
  			 int count = 0;
  			 for (i = 0; i < s; i++) {
  				 if (f[i])
  					 count++;  // 카운트 증가
  			 }
  			 
  			 int[] primes = new int[count];
  			 
  			 // 소수를 결과 배열로 이동한다.
  			 for (i = 0, j = 0; i < s; i++) {
  				 if (f[i])  // 소수일 경우에
  					 primes[j++] = i;
  			 }
  			 
  			 return primes;  // 소수를 반환한다.
  		 }
  		else // maxValue < 2
  				 return new int[0];  // 입력이 잘못되면 비어 있는 배열을 반환한다.
  	}
   }
  ```
  *위 코드를 리팩터링한 결과*
  ```java
  /**
   * 이 클래스는 사용자가 지정한 최대 값까지 소수를 구한다.
   * 알고리즘은 에라스토테네스의 체다.
   * 2에서 시작하는 정수 배열을 대상으로 작업한다.
   * 처음으로 남아 있는 정수를 찾아 배수를 모두 제거한다.
   * 배열에 더 이상 배수가 없을 때까지 반복한다.
   */
   public class PrimeGenerator {
  	private static boolean[] crossedOut;
  	private static int[] result;
  	
  	public static int[] generatePrimes(int maxValue) {
  		if (maaxValue < 2)
  			return new int[0];
  		else {
  			uncrossIntegersUpTo(maxValue);
  			crossOutMultiples();
  			putUncrossedIntegerIntoResult();
  			return result;
  		}
  	}
  	
  	private static void uncrossIntegersUpTo(int maxValue) {
  		crossedOut = new boolean[maxValue + 1];
  		for (int i = 2; i < crossedOut.length; i++)
  			crossedOut[i] = false;
  	}
  	
  	private static void crossOutMultiples() {
  		int limit = determineIterationLimit();
  		for (int i = 2; i <= limit; i++)
  			if (notCrossed(i))
  				crossOutMultiplesOf(i);
  	}
  	
  	private static int determineIterationLimit() {
  		// 배열에 있는 모든 배수는 배열 크기의 제곱근보다 작은 소수의 인수다.
  		// 따라서 이 제곱근보다 더 큰 숫자의 배수는 제거할 필요가 없다
  		dobule iterationLimit = Math.sqrt(crossedOut.length);
  		return (int) iterationLimit;
  	}
  	
  	private static void crossOutMultiplesOf(int i) {
  		for (int multiple = 2 * i; multiple < crossedOut.length; multiple += i)
  			crossedOut[multiple] = true;
  	}
  	
  	private static boolean notCrossed(int i) {
  		return crossedOut[i] == false;
  	}
  	
  	private static void putUncrossedIntegersIntoResult() {
  		result = new int[numberOfUncrossedIntegers()];
  		for (int j = 0, i = 2; i < crossedOut.length; i++)
  			if (notCrossed(i))
  				result[j++] = i;
  	}
  	
  	private static int nubmerOfUncrossedIntegers() {
  		int count = 0;
  		for (int i = 2; i < crossedOut.length; i++)
  			if (notCrossed(i))
  				count++;
  		
  		return count;
  	}
   }
  ```
  첫 번째 주석은 generatePrimes 함수 자체와 중복이라고 볼 수 있지만, 주석이 있어 알고리즘을 이해하기 쉬워진다. 두 번째 주석은 루프 한계값으로 제곱근을 사용한 이유(의도) 명시