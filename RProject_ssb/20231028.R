ID <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
SEX <- c("F", "M", "F", "M", "M", "F", "F", "F", "M", "F")
AGE <- c(50, 40, 28, 50, 27, 23, 56, 47, 20, 38)
AREA <- c('서울', '경기', '제주', '서울', '서울', '서울', '경기', '서울', '인천', '경기')

dataframe_ex <- data.frame(ID, SEX, AGE, AREA)
dataframe_ex
str(dataframe_ex)
dataframe_area <- dataframe_ex$AREA
dataframe_area

var1 <- c(1, 2, 5, 7, 8)
var1


var2 <- c(1:100)
var2

var3 <- seq(1, 200)
var3

var4 <- seq(1, 100, by=2)
var4

var6 <- seq(1, 10, by=3)
var6

str1 <- 'a'
str1

str2 <- 'Hello World!'
str2

str3 <- c('a', 'b', 'c')
str3

'R에서는 문자로 된 변수로는 연산을 할 수 없다.'
str1+2

'함수(function) : 기능을 하는 수'

### 숫자를 다루는 함수

x <- c(1, 2, 3)

# 평균 산출 함수
mean(x)
mean(dataframe_ex$AGE)
#최대값, 최소값 산출 함수
max(x)
min(x)

### 문자열을 다루는 함수
str5 <- c('hello!', "World", "is", "good!")
str5

# 구분자를 줘서 단어를 합치는 함수
paste(str5, collapse = ' ')

'함수의 옵션 설정하기 -파라미터, 매개변수'

#함수의 출력 결과물로 새 변수를 만들기
x_mean <- mean(x)

str5_paste <- paste(str5, collapse = '-')

'패키지 : 함수들의 꾸러미'
'
그래프를 그릴 때 사용하는 "ggplot2" 패키지
'

### 패키지 설치 & 사용
install.packages('ggplot2')
library(ggplot2) # 사용 함수

x <- c('a', 'a', 'b', 'c')

# 빈도(개수를 세는) 막대 그래프 생성
qplot(x)
qplot(dataframe_ex$AREA)

## ggplot2 mpg 데이터로 여러 그래프 만들기
'
mpg 데이터: 미국 환경 보호국에서 공개한 데이터로, 1999-2008년도 사이 미국에서 출시된 자동차 234종의 연비 관련 정보를 담고 있다.
'
# 데이터 로드
mpg <- as.data.frame(ggplot2::mpg)

# data에 mpg, x축에 hwy(고속도로 연비) 변수 지정해서 그래프 생성
qplot(data=mpg, x=hwy)

# qplot 함수에 여러개의 파라미터 (x축y축 따로 지정)
qplot(data=mpg, x=cty, y=hwy)

# x축 drv(구동방식), y축 hwy, 선그래프 만들기
qplot(data=mpg, x=drv, y=hwy, geom='line')

# x축에 drv, y축에 상자 그림 그래프 만들기
qplot(data = mpg, x=drv, y=hwy, geom = 'boxplot')

# 상자그림에 구동 방식별로 색 표현
qplot(data = mpg, x=drv, y=hwy, geom = 'boxplot', colours('drv'))

# qplot help 함수
?qplot

# 데이터 프레임 한번에 만들기
df_midt <- data.frame(end = c(90, 80, 70, 60),
                      mth = c(50, 60, 70, 100),
                      cls = c(1,2,3,4))
df_midt
