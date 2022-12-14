# 12장 창발성(創發性)

# 창발적 설계로 깔끔한 코드를 구현하자

- 우수한 설계의 창발성을 촉지하는 원칙이 있다.

## 켄드 벡이 제시한 ‘단순한 설계 규칙 네가지’

켄트 백은 다음 규칙을 따르면 설계는 ‘단순하다’고 한다. 순서는 중요도 순이다.

1. 모든 테스트를 실행한다.
2. 중복을 없앤다.
3. 프로그래머 의도를 표현한다.
4. 클래스와 메서드 수를 최소로 줄인다.

# 단순한 설계 규칙 1: 모든 테스트를 실행하라

- 무엇보다 의도한 대로 돌아가는 시스템을 내놓아야 한다.
- 문서로는 시스템을 완벽하게 설계했지만 시스템이 의도한대로 돌아가는지 검증할 간단한 방법이 없다면 문서 작성을 위해 투자한 노력에 대한 가치를 인정받기 힘들다.
- 테스트를 철저히 거쳐 모든 테스트 케이스를 항상 통과하는 시스템은 ‘테스트가 가능한 시스템’이다.
- 테스트가 불가능한 시스템은 검증도 불가능하다.
- 테스트가 가능한 시스템을 만들려고 애쓰면 설계 품질이 더불어 높아진다.
    - SRP를 준수하는 클래스는 테스트가 더 쉽다.
    - 결합도가 높으면  테스트 케이스를 작성하기 어렵다.
    - 개발자는 DIP와 같은 원칙을 적용하고 의존성 주입(Dependency Injection), 인터페이스, 추상화 등과 같은 도구를 사용해 결합도를 낮춘다.
- 테스트 케이스를 만들고 계속 돌려라
    - 시스템은 낮은 결합도와 높은 응집력이라는 객체 지향 방법론이 지향하는 목표를 저절로 달성한다.
- 테이트 케이스를 작성하면 설계 품질이 높아진다.

# 단순한 설계 규칙 2~4: 리팩터링

- 구체적으로는 코드를 점진적으로 리팩토링해나간다.
- 코드를 정리하면서 시스템이 깨질까 걱정할 필요가 없다. 테스트 케이스가 있으니까!
- 리팩토링 단계에서는 소프트웨어 설계 품질을 높이는 기법을 무엇이라도 적용해도 된다.

# 중복을 없애라

- 우수한 설계에서 중복은 커다란 적이다.
    - 중복은 추가 작업, 추가 위험, 불필요한 복잡도를 뜻하기 때문이다.
- 구현 중복도 중복의 한 형태이다.
- Template Method 패턴은 고차원 중복을 제거할 목적으로 자주 사용하는 기법이다.

# 표현하라

- 자신이 이해하는 코드를 짜기는 쉽다. 코드를 짜는 동안에는 문제에 푹 빠져 코드를 구석구석 이해한다. 하지만 나중에 코드를 유지보수할 사람이 코드를 짜는 사람만큼 문제를 깊이 이해하는 가능성은 희박하다.
- 소프트웨어 프로젝트 비용 중 대다수는 장기적인 유지보수에 들어간다. 코드를 변경하면서 버그의 싹을 심지 않으려면 유지보수 개발자가 시스템을 제대로 이해해야 한다.
    1. 좋은 이름을 선택한다.
        - 이름과 기능이 딴판인 클래스나 함수로 유지보수 담당자를 놀라게해서는 안된다.
    2. 함수와 클래스 크기를 줄인다.
        - 작은 클래스와 작은 함수는 이름 짓기도 쉽고 구현하기도 쉽고 이해하기도 쉽다.
    3. 표준 명칭을 사용한다.
        - 디자인패턴은 의사소통과 표현력 강화가 주요 목적이다.
        - Command, Visitior 같은 표준 패턴을 사용하면 이름에 패턴을 넣어준다.
        - 다른 개발자가 클래스 설계 의도를 이해하기 쉬워진다.
    4. 단위 테스트 케이스를 꼼꼼히 작성한다.
        - 테스트 케이스는 예제로 보여주는 문서이다.
        - 잘 만든 테스트 케이스를 읽어보면 클래스 기능이 한눈에 들어온다.
    
    표현력을 높이는 가장 중요한 방법은 노력이다. 코드만 돌린 후 다음 문제로 직행하는 사례가 너무나 흔하다. 나중에 읽는 사람을 위해 읽기 쉽게 만들려는 충분한 고민을 해야한다. 왜냐하면 나중에 코드를 읽을 사람이 바로 자신일 가능성이 높다.
    

# 클래스와 메서드 수를 최소로 줄여라

- 중복을 제거하고 의도를 표현하고 SRP를 준수하는 기본적인 개념도 극단으로 치달으면 득보다 실이 많아진다.
- 때로는 무의미하고 독단적인 정책 탓에 클래스 수와 메서드 수가 늘어나기도 한다.
    - 클래스마다 무조건 인터페이스를 생성하라고 요구하는 구현 표준이 예시이다.
    - 자료 클래스와 동작 클래스는 무조건 분리해야 한다고 주장하는 개발자도 좋은 예다.
    - 가능한 독단적인 견해는 멀리하고 실용적인 방식을 택한다.
- 목표는 함수와 클래스 크기를 작게 유지하면서 동시에 시스템 크기도 작게 유지하는 데 있다.
    - 다만 이 규칙은 간단한 설계 규칙 중에서 우선순위가 가장 낮다.
    - 클래스와 함수 수를 줄이는 작업도 중요하지만 테스트 케이스를 만들고 중복을 제거하고 의도를 표현하는 작업이 더 중요하다는 뜻이다.

# 결론

- 경험을 대신할 단순한 개발 기법이 있을까?
    - 이 책에서 소개하는 기법은 저자들이 수십년동안 경험의 정수다.
    - 설계 규칙을 따른다면 우수한 기법과 원칙을 단번에 활용할 수 있다.
