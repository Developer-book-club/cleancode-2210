# 5장 형식 맞추기

프로그래머라면 형식을 깔끔하게 맞춰 코드를 짜야한다. 코드 형식을 맞추기 위한 간단한 규칙을 정하고 그 규칙을 착실히 따라야한다. 팀으로 일한다면 팀이 합의해 규칙을 정하고 모두가 그 규칙을 따라야 한다. 필요하다면 규칙을 자동으로 적용하는 도구를 활용한다.

## 형식을 맞추는 목적

* 코드 형식은 의사소통의 일환이고 의사소통은 전문 개발자의 일차적인 의무(돌아가는 코드가 아니다)
* 오늘 구현한 기능은 다음 버전에서 바뀔 확률이 높으나, 오늘 구현한 코드의 가독성은 앞으로 바뀔 코드의 품질에 영향을 끼친다.
* 원래 코드는 사라질지라도 개발자의 스타일과 규율은 사라지지 않고, 맨 처음 잡아놓은 구현 스타일과 가독성 수준은 유지보수 용이성과 확장성에 계속 영향을 끼친다.

## 적절한 행 길이를 유지하라

코드의 세로 길이(라인 수)는 대부분 200줄 정도로도 커다란 시스템을 구축할 수 있다. 일반적으로 큰 파일보다 작은 파일이 이해하기 쉽다.

## 신문 기사처럼 작성하라

* 신문기사의 특징
	* 독자는 위에서 아래로 읽으며 표제를 보고서 기사를 읽을지 말지 결정
	* 최상단 표제 : 기사를 몇 마디로 요약
	* 첫 문단 : 전체 기사 내용 요약(큰 그림)
	* 쭉 읽어내려가며 날짜, 이름, 발언, 주장, 기타 세부사하

* 소스코드
	* 소스 파일 이름은 간단하면서도 설명이 가능하게 짓고, 이름만 보고도 올바른 모듈인지 판단하도록
	* 소스 파일 첫부분은 고차원 개념과 알고리즘 설명
	* 아래로 내려갈수록 의도를 세세하게 묘사
	* 마지막에는 가장 저차원 함수와 세부 내역

## 개념은 빈 행으로 분리하라

거의 모든 코드는 왼쪽에서 오른쪽으로, 위에서 아래로 읽히며 각 행은 수식이나 절을 나타내며 일련의 행 묶음은 완결된 생각 하나를 표현하기때문에 생각 사이에는 빈 행을 넣어 분리(ex. 패키지 선언부, import 문, 각 함수 사이). 빈 행을 빼버리면 가독성이 현저하게 떨어진다.

## 세로 밀집도

줄바꿈은 개념 분리, 세로 밀집도는 연관성 의미. 밀접한 코드 행은 세로로 가까이 놓아야 한다.(ex. 인스턴스 변수끼리 밀집)

## 수직 거리

함수 연관 관계와 동작 방식을 이해하기 위해, 서로 밀접한 개념은 세로로 가까이 두어야한다. 서로 밀집한 개념은 한 파일에 속해야 한다(protected 변수를 피해야 하는 이유). 

* 변수 선언 : 변수는 사용하는 위치에 최대한 가까이(사용 직전)
* 인스턴스 변수 : 잘 설계한 클래스는 많은(대부분) 클래스 메서드가 인스턴스 변수를 사용하기 때문에 클래스 맨 처음에 선언. 또는 잘 알려진 위치에 선언해야 한다.
* 종속 함수 : 연관 관계가 있는 함수는 세로로 가까이 배치, 호출하는 함수를 호출되는 함수보다 먼저 배치. 호출되는 함수를 찾기가 쉬워지며 모듈 전체의 가독성이 높아진다.
  ```java
  public class WikiPageResponder implements SecureResponder {
  	protected WikiPage page;
  	protected PageData pageData;
  	protected String pageTitle;
  	protected Request request;
  	protected PageCrawler crawler;
  	
  	public Response makeResponse(FitNesseContext context, Request request) throws Exception {
  		String pageName = getPageNameOrDefault(request, "FrontPage");
  		loadPage(pageName, context);
  		if (page == null)
  			return notFoundResponse(context, request);
  		else
  			return makePageResponse(context);
  	}
  	
  	private String getPageNameOrDefault(Request request, String defaultPageName) {
  		String pageName = request.getResource();
  		if (StringUtil.isBlank(pageName))
  			pageName = defaultPageName;
  		
  		return pageName;
  	}
  	
  	protected void loadPage(String resource, FitNesseContext context) throws Exception {
  		WikiPagePath path = PathParser.parse(resource);
  		crawler = context.root.getPageCrawler();
  		crawler.setDeadEndStrategy(new VirtualEnabledPageCrawler());
  		page = crawler.getPage(context.root, path);
  		if (page != null)
  			pageData = page.getData();
  	}
  	
  	private Response notFoundResponse(FitNesseContext context, Request request) throws Exception {
  		return new NotFoundResponder().makeResponse(context, request);
  	}
  	
  	private SimpleResponse makePageResponse(FitNesseContext context) throws Exception {
  		pageTitle = PathParser.render(crawler.getFullPath(page));
  		String html = makeHtml(context);
  	
  		SimpleResponse response = new SimpleResponse();
  		response.setMaxAget(0);
  		response.setContent(html);
  		return response;
  	}
  }
  ```
  *getPageNameOrDefault 함수 안에서 "FrontPage" 상수를 사용할 수도 있지만, 상수를 알아야 마땅한 함수에서 실제로 사용하는 함수로 상수를 넘겨주는 방법이 더 좋다*

## 개념적 유사성

프로그래머는 명백하게 짧은 행을 선호하며, 100~120자 정도가 적당하다.

## 가로 공백과 밀집도

* 가로로는 공백을 사용해 밀접한 개념과 느슨한 개념 표현
  ```java
  private void measureLine(String line {
  	lineCount++;
  	int lineSize = line.length();
  	totalChars += lineSize;
  	lineWidthHistogram.addLine(lineSize, lineCount);
  	recordWidestLine(lineSize);
  )
  ```
	* 할당 연산자(=)를 강조하기 위해 공백 추가. 공백을 넣어 왼쪽 요소와 오른쪽 요소를 확실히 분리
	* 함수 이름과 이어지는 괄호 사이에는 공백이 없어 한 개념으로 표시(함수와 인수는 서로 밀접)
	* 함수를 호출하는 코드에서도 괄호 안 인수끼리는 공백으로 분리(쉼표를 강조해 별개라는 사실을 보여줌)

* 연산자 우선순위를 강조하기 위해 공백 사용
  ```java
  public class Quadratic {
  	public static double root1(double a, double b, double c) {
  		double determinant = determinant(a, b, c);
  		
  		return (-b + Math.sqrt(determinant)) / (2*a);
  	}
  	
  	public static double root2(int a, int b, int c) {
  		double determinant = determinant(a, b, c);
  		return (-b - Math.sqrt(determinant)) / (2*a);
  	}
  	
  	private static double determinant(double a, double b, double c) {
  		return b*b - 4*a*c;
  	}
  }
  ```
	*승수 사이에는 공백이 없고, 항 사이에는 공백이 들어간다(b\*b - 4\*a\*c). 곱셈은 우선순위가 가장 높고 덧셈과 뺄셈은 우선순위가 곱셈보다 낮기 때문*

## 가로 정렬

과거(어셈블리어 시절)에는 선언부의 변수 이름이나, 할당문의 오른쪽 피연산자를 나란히 정렬했으나, 현재는 해당 코드가 엉뚱한 부분을 강조해 진짜 의도가 가려질 수 있다(ex. 선언부의 변수 유형 대신 변수 이름 강조, 할당 연산자 대신 피연산자 강조). 정렬이 필요할 정도로 목록이 길다면 문제는 목록 길이지 정렬 부족이 아니므로 클래스를 쪼개야 한다는 의미다.
```java
public class FitNesseExpediter implements ResponseSender {
	private   Socket       socket;
	private   InputStream  input;
	private   OutputStream output;
	private   Request      request;
	private   Response     response;
	protected long         requestParsingTimeLimit;
	private   long         requestProgress;
	private   long         requestParsingDeadline;
	private   boolean      hasError;
	
	public FitNesseExpediter(Socket          s,
				 FitNesseContext context) throws Exception {
		this.context =            context;
		socket =                  s;
		input =                   s.getInputStream();
		output =                  s.getOutputStream();
		requestParsingTimeLimit = 10000;
	}
}
```

## 들여쓰기

* 소스 파일은 윤곽도(outline)와 계층이 비슷하다. **파일** 전체에 적용되는 정보, 파일 내 개별 **클래스**에 적용되는 정보, 클래스 내 각 **메서드**에 적용되는 정보, **블록** 내 블록에 재귀적으로 적용되는 정보.(계층에서 각 수준은 이름을 선언하는 범위이자 선언문과 실행문을 해석하는 범위)
* 범위(scope)로 이루어진 계층을 표현하기 위해 들여쓰기 사용
* 파일 수준(클래스 정의)은 들여쓰지 않고, 클래스 내 메서드는 클래스보다 한 수준 들여쓰고, 클래메서드 코드는 메서드 선언보다 한 수준 들여쓴다. 블록 코드는 블록을 포함하는 코드보다 한 수준 들여쓴다.
* 코드가 속하는 범위를 시각적으로 표현하여 범위 간의 이동 수월
* **들여쓰기 무시하기** : 간단한 if 문, 짧은 while 문에서는 들여쓰기를 무시하고 싶을 수 있지만, 한행에 뭉뚱그린 코드를 피하고 들여쓰기로 범위를 제대로 표현하자.
* **가짜 범위** : 빈 while 문이나 for 문은 범위가 눈에 띄게 하기위해 빈 블록을 올바로 들여쓰고 괄호로 감싸는 것이 좋다. 세미 콜론(;)은 새 행에다 제대로 들여써서 넣어주자.

## 팀 규칙

프로그래머라면 각자 선호하는 규칙이 있지만, 팀에 속한다면 팀 규칙을 선호해야 한다. 팀은 한 가지 규칙에 합의하고 모든 팀원은 해당 규칙을 따라야 한다. 정한 규칙으로 IDE 코드 형식기를 설정하여 일관적인 스타일을 유지하라.