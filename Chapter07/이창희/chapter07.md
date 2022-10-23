# 7. 오류 처리

오류 처리 코드가 흩어져있으면 프로그램의 논리를 이해하기 어렵기 때문에, 깨끗한 코드와 오류 처리는 확실한 연관성이 존재한다.

## 오류 코드보다 예외를 사용하라

* 예외를 지원하지 않은 언어에서 오류를 처리하고 보고하는 방법 : 오류 플래그를 설정하거나, 호출자에게 오류 코드를 반환(함수 호출 즉시 오류를 확인해야하여 호출자 코드가 복잡해짐)
* 오류가 발생하면 예외를 던지도록하면 논리가 오류 처리 코드와 분리된다.

## Try-Catch-Finally 문부터 작성하라

* try 블록에서 무슨 일이 생기든지 catch 블록은 프로그램 상태를 일관성 있게 유지해야 한다.
* 예외가 발생할 코드에서 try-catch-finally 문으로 시작하면 호출자가 기대하는 상태를 정의하기 쉬워진다.
* 예시(파일이 없으면 예외를 던지는지 알아보는 단위 테스트)
  ```java
  @Test(expected = StorageException.class)
  public void retrieveSectionShouldThrowOnInvalidFileName() {
  	sectionStore.retrieveSection("invalid - file");
  }
  ```
  단위 테스트에 맞춰 코드 구현
  ```java
  public List<RecordedGrip> retrieveSection(String sectionName) {
  	// 실제로 구현할 때까지 비어 있는 더미를 반환한다.
  	return new ArrayList<RecordedGrip>();
  }
  ```
  단위테스트 실패 -> 잘못된 파일 접근을 시도하게 구현 변경
  ```java
  public List<RecordedGrip> retrieveSection(String sectionName) {
  	try {
  		FileInputStream stream = new FileInputStream(sectionName)
  	} catch (Exception e) {
  		throw new StorageException("retrieval error", e);
  	}
  	return new ArrayList<RecordedGrip>();
  }
  ```
  코드가 예외를 던져 테스트 성공 -> 리팩터링(catch 블록에서 예외 유형을 좁혀 실제로 FileInputStream 생성자가 던지는 FileNotFoundException을 잡도록 개선)
  ```java
  public List<RecordedGrip> retrieveSection(String sectionName) {
  	try {
  		FileInputStream stream = new FileInputStream(sectionName)
  		stream.close();
  	} catch (FileNotFoundException e) {
  		throw new StorageException("retrieval error", e);
  	}
  	return new ArrayList<RecordedGrip>();
  }
  ```
  try-catch 구조로 범위를 정의했으므로 TDD를 사용해 필요한 나머지 논리를 추가(FileInputStream을 생성하는 코드와 close 호출문 사이에 넣으며 오류나 예외가 발생하지 않는다고 가정)<br>위와 같이 먼저 강제로 예외를 일으키는 테스트 케이스를 작성한 후 코드를 작성하면 자연스럽게 try 블록의 트랜잭션 범위부터 구현하게 되므로 범위 내에서 트랜잭션 본질을 유지하기 쉬워진다.

## 미확인 예외(unchecked Exception)를 사용하라

* 확인된 예외(checked Exception)는 메서드를 선언할 때, 메서드가 반환할 모든 예외를 열거해야하기 때문에, OCP를 위반한다.(throws 경로에 위치하는 모든 함수가 최하위 함수에서 던지는 예외를 알아야하기 때문에 캡슐화가 깨진다.)
* 때로는 아주 중요한 라이브러리를 작성할 때는 모든 예외를 잡아야하기 때문에 checked Exception이 유용할 수 있다.

## 예외에 의미를 제공하라

호출 스택만으로 실패한 코드의 의도를 파악하기 어렵기 때문에, 오류 메시지에 정보(전후 상황)를 담아 예외와 함께 던진다(실패한 연산이름, 실패 유형).

## 호출자를 고려해 예외 클래스를 정의하라

* 오류를 정의할 때 프로그래머에게 가장 중요한 관심사는 오류를 잡아내는 방법
* 예시(오류를 형편없이 분리한 사례 - 외부 라이브러리가 던질 예외를 모두 잡아낸다)
  ```java
  ACMEPort port = new ACMEPort(12);
  
  try {
  	port.open();
  } catch (DeviceResponseException e) {
  	reportPortError(e);
  	logger.log("Device response exception", e)
  } catch (ATM1212UnlockedException e) {
  	reportPortError(e);
  	logger.log("Unlock exception", e);
  } catch (GMXError e) {
  	reportPortError(e);
  	logger.log("Device response exception");
  } finally {
  	...
  }
  ```
  위 경우는 예외에 대응하는 방식이 예외 유형과 무관하게 거의 동일하기 때문에, 아래와 같이 호출하는 라이브러리 API를 감싸면서 유형 하나를 반환하여 개선 가능
  ```java
  LocalPort port = new LocalPort(12);
  try {
  	port.open();
  } catch (PortDeviceFailure e) {
  	reportPortError(e);
  } finally {
  	...
  }
  
  public class LocalPort {
  	private ACMEPort innerPort;
  	
  	public LocalPort(int portNumber) {
  		innerPart = new ACMEPort(portNumber);
  	}
  	
  	public void open() {
  		try {
  			innerPort.open();
  		} catch (DeviceResponseException e) {
  			reportPortError(e);
  			logger.log("Device response exception", e)
  		} catch (ATM1212UnlockedException e) {
  			reportPortError(e);
  			logger.log("Unlock exception", e);
  		} catch (GMXError e) {
  			reportPortError(e);
  			logger.log("Device response exception");
  		}
  	}
  }
  ```
  * LocalPort 클래스는 단순히 ACMEPort 클래스가 던지는 예외를 잡아 변환하는 감싸기(Wrapper) 클래스이며 외부 API를 사용할 때는 감싸기 기법이 최선 -> 외부 라이브러리와 프로그램 사이의 의존성 감소(라이브러리 교체, 테스트가 쉬워짐)
* 예외 클래스에 포함된 정보로 오류를 구분해도 괜찮은 경우 예외 클래스가 하나만 있어도 충분
* 한 예외는 잡아내고 다른 예외는 무시해도 괜찮은 경우라면 여러 예외 클래스 사용

## 정상 흐름을 정의하라

* 위 지침대로 외부 API를 감싸 독자적인 예외를 던지고, 코드위에 처리기를 정의해 중단된 계산을 처리할 수 있지만, 때로는 중단이 적합하지 않을 때도 있다.
* 예시(비용 청구 애플리케이션에서 총계를 계산하는 허술한 코드)
  ```java
  try {
  	MealExpenses expenses = expenseReportDAO.getMeals(employee.getID());
  	m_total += expenses.getTotal();
  } catch(MealExpensesNotFound e) {
  	m_total += getMealPerDiem();
  }
  ```
  위 코드는 예외가 논리를 따라가기 어렵게 만들기 때문에, 아래와 같이 특수한 상황을 처리하지 않도록하면 코드가 더 간결해진다.
  ```java
  MealExpenses expenses = expenseReportDAO.getMeals(employee.getID());
  m_total += expenses.getTotal();
  ```
  특수한 경우에 대한 처리는 ExpenseReportDAO를 고쳐 청구한 식비가 없다면 일일 기본 식비를 반환하는 MealExpense 객체를 반환한다.
  ```java
  public class PerDiemMealExpenses implements MealExpenses {
  	public int getTotal() {
  		// 기본값으로 일일 식비를 반환한다.
  	}
  }
  ```
  위와 같은 방법을 **특수 사례 패턴**(**SPECIAL CASE PATTERN**)이라고 한다(클래스를 만들거나 객체를 조작해 특수 사례를 처리). -> 클래스나 객체가 예외적인 상황을 캡슐화해서 클라이언트 코드가 예외적인 상황을 처리할 필요가 없어짐

## null을 반환하지 마라

* 흔히 저지르는 바람에 오류를 유발하는 행위 ex) null을 반환하는 습관
  ```java
  public void registerItem(Item item) {
  	if (item != null) {
  		ItemRegistry registry = persistentStore.getItemRegistry();
  		if (registry != null) {
  			Item existing = registry.getItem(item.getID());
  			if (existing.getBillingPeriod().hasRetailOwner()) {
  				existing.register(item);
  			}
  		}
  	}
  }
  ```
  * null을 반환하는 코드는 일거리를 늘릴 뿐만 아니라 호출자에게 문제를 떠넘긴다.
  * 누구 하나라도 null 확인을 빼먹으면 애플리케이션이 통제 불능에 빠진다.
  * persistentStore에서 null이 반환되면 NullPointException이 발생한다.
  * 메서드에서 null을 반환하는 대신 예외를 던지거나 특수 사례 객체를 반환하는 방식을 고려
  * 사용하려는 외부 API가 null을 반환하면 감싸기(Wrapper) 메서드를 구현해 예외를 던지거나 특수 사례 객체를 반환하는 방식을 고려
  * 많은 경우 특수 사례 객체가 손쉬운 해결책이다.
    ```java
    List<Employee> employees = getEmployees();
    if (employees != null) {
    	for(Employee e : employees) {
    		totalPay += e.getPay();
    	}
    }
    ```
    위와 같은 코드에서 getEmployees를 변경해 빈 리스트를 반환하면 코드가 더 깔끔해진다.
    ```java
    List<Employee> employees = getEmployees();
    for(Employee e : employees) {
    	totalPay += e.getPay();
    }
    ```
    java에서는 Collection.emptyList()가 있어 미리 정의된 읽기 전용 리스트를 반환할 수 있다.
    ```
    puvlic List<Employee> getEmployees() {
    	if (.. 직원이 없다면 ..)
    		return Collections.emptyList();
    }
    ```

## null을 전달하지 마라

* 정상적인 인수로 null을 기대하는 API가 아니라면 메서드로 null을 전달하는 코드는 최대한 피한다.
  ```java
  public class MetricsCalculator {
  	public double xProjection(Point p1, Point p2) {
  		return (p2.x - p1.x) * 1.5;
  	}
  }
  ```
  `calculator.xProjection(null, new Point(12, 13));`과 같이 인수로 null을 전달하면 NullPointException이 발생 -> 새로운 예외 유형을 만들어 던지는 방법 고려

  ```java
  public class MetricsCalculator {
  	public double xProjection(Point p1, Point p2) {
  		if (p1 == null || p2 == null) {
  			throw InvalidArgumentException(
  				"Invalid argument for MetricsCalculator.xProjection");
  		}
  		return (p2.x - p1.x) * 1.5;
  	}
  }
  ```
  NullPointException은 피할 수 있으나 InvalidArgumentException을 잡아내는 처리기가 필요 -> assert 문 사용 고려

  ```java
  public class MetricsCalculator {
  	public double xProjection(Point p1, Point p2) {
  		assert p1 != null : "p1 should not be null";
  		assert p2 != null : "p2 should not be null";
  		return (p2.x - p1.x) * 1.5;
  	}
  }
  ```
  코드 읽기는 편하나 여전히 null이 전달되면 실행 오류 발생(처리기 필요)
* 대다수 프로그래밍 언어는 호출자가 실수로 넘기는 null을 적절히 처리하는 방법이 없기 때문에, 애초에 null을 넘기지 못하도록 금지하는 정책이 합리적이다.