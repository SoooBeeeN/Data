'외부 데이터 활용 - 시험 성적 데이터 로드'

### 엑셀 파일 불러오기
install.packages('readxl')
library(readxl)

df_exam <- read_excel('excel_exam.xlsx')
df_exam

mean(df_exam$english)

# 경로 지정해서 불러오기
'R 에서는 디스크명 소문자로 쓰고
경로를 구분할 때는 슬레쉬 쓴다.'

# 엑셀 파일 첫 행이 변수명이 아닌 데이터로 시작하는 경우
df_exam_novar <- read_excel('excel_exam_novar.xlsx') 동작시 
첫 행이 변수화 되어 데이터가 변함
df_exam_novar <- read_excel('excel_exam_nover.xlsx', col_names = F '첫 행이 변수명이 아님을 선언')

# 엑셀에 시트가 여러 개 있는 경우
df_exam_sheet <- read_excel('excel_exam_sheet.xlsx', sheet = 3 '읽어올 시트 지정')

# .csv 파일 로드
'1. csv <- 값 사이를 쉼표로 구분한 파일
 2. 용량이 작음, 다양한 소프트웨어에서 사용'
df_csv_exam <- read.csv('csv_exam.csv')

# ------------------------------------------------

''' 데이터 파악 - 다루기 쉽게 수정 '''

'- 데이터 파악 함수
  1. head() : 데이터 앞 부분 출력
  2. tail() : 데이터 뒷 부분 출력
  3. View() : 뷰어 창에서 데이터 확인 (환경콘솔에서 더블클릭해 여는것과 동일
  4. dim() : 데이터의 차원 출력
  5. str() : 데이터의 속성을 출력
  6. summary() : 요약 통계량 출력'

exam <- read.csv('csv_exam.csv')

head(df_exam, 3)
tail(df_exam, 5)
dim(df_exam)
str(df_exam)
summary(df_exam)

### mpg 데이터 파악
'ggplot2dml mpg 데이터'
mpg <- as.data.frame(ggplot2::mpg)
head(mpg)
tail(mpg)
str(mpg)
summary(mpg)

' 데이터 수정 - 변수명 수정 '

### dplyr 패키지  : 데이터 처리에 특화된 패키지, 데이터 프레임 조작
install.packages('dplyr')
library(dplyr)

df_raw <- data.frame(var1 = c(1,2,1),
                     var2 = c(2,3,2))
'기존의 데이터를 수정할 때는 기존 데이터를 복사한
복사 데이터를 사용해서 수정을 한다.'

# 데이터 복사본 생성
df_new <- df_raw

# 변수명 수정 (새 변수명 = 기존 변수명 순서로 입력)
df_new <- rename(df_new, v2 = var2) # 덮어쓰기
a <- rename(df_new, v2 = var2) # 새로 생성

'
Q1. mpg 데이터 복사본 생성하세요.
Q2. cty는 city로, hwy는 highway로 변수명 수정하시고 일부를 10행만 출력하세요.
'
mpg_copy <- mpg
mpg_copy <- rename(mpg_copy, city = cty, highway = hwy)
head(mpg_copy, 10)

'
파생 변수 생성 - 기존 변수를 활용해서 새로 만드는 변수
'

### mpg데이터에서 통합 연비 변수 생성
mpg$total <- (mpg$cty + mpg$hwy) / 2
head(mpg$total)
head(mpg, 10)

### 조건문을 활용한 파생 변수 생성

# 기준값(조건문에 활용할 수나 조건)을 정하기
summary(mpg$total) # 문자로 보는법
hist(mpg$total) # 그래프로 보는법

# 합격 판정 변수 생성
# 통합 연비가 20 이상이면 Pass, 아니면 fail - 조건
mpg$test <- ifelse(mpg$total >= 20, 'pass', 'fail')
head(mpg)
tail(mpg, 20)

# 빈도표 생성 - table() 함수
table(mpg$test)
library(ggplot2)
qplot(mpg$test)

### 중첩 조건문 - 조건문 안에 조건문
'
A등급 : 30이상
B등급 : 20-29
C등급 : 20 미만
'
# total 기준으로 등급 부여
mpg$grade <- ifelse(mpg$total >= 30, 'A', 
                    ifelse(mpg$total>= 20, 'B', 'C'))
head(mpg, 20)
table(mpg$grade)
qplot(mpg$grade)

#---------------------------------------------------------------------
'데이터 가공 - 데이터를 원하는 형태로 만드는 것 (전처리)'
' 전처리 함수
1. filter() : 행 추출 함수
2. select() : 열(변수) 추출함수
3. arrange() : 정렬
4. mutate() : 변수 추가
5. summarise() : 통계치 산출
6. group_by() : 집단별로 데이터 나누기
7. left_join() : 데이터 합치기(열 기준)
8. bind_rows() : 데이터 합치기(행 기준) 
'
 ### 조건에 맞는 데이터만 추출
' %>% : 파이프 기호 -> 전처리 함수들을 연결'
' 조건문에서 같다는 의미는 == (등호 2개) '

df_exam %>% filter(class == 2) # 변수명에 $나 ''기호를 쓸 필요가 X
df_exam %>% filter(class != 2)
df_exam %>% filter(math < 50)

'
1. & (그리고, and) : 두 조건 모두 충족
2. | (또는, or) : 두 조건 중 하나라도 충족
'

df_exam %>% filter(class == 2 & english > 90)
df_exam %>% filter(math >= 90 | english >= 90)
df_exam %>% filter(class == 1 | class == 3 | class == 5)
' %in% : 포함 연산자 '
df_exam %>% filter(class %in% c(1,3,5))

class1 <- df_exam %>% filter(class == 1)
class1
mean(class1$math)


' R에서 사용하는 기호 
- 논리 연산자
  1. > <
  2. >= <=
  3. ==
  4. !=
  5. %in% :포함 연산자, 매칭
  
- 산술 연산자
  1. + -
  2. *
  3. ^, ** : 제곱
  4. /
  5. %/% : 나눗셈의 몫
  6. %% : 나눗셈의 나머지
'
# exam 짝수 번호 출력
df_exam %>% filter(id %% 2 == 0)

### 필요한 변수만 추출
df_exam %>% select(math)
df_exam %>% select(class, math, english)
df_exam %>% select(-math, -english)

'dplyr 패키지 함수들 조합'
# 1반 학생들의 영어 점수만 조회
df_exam %>% 
  filter(class == 1) %>% 
  select(english)

# id, math 추출하고 앞부분 6행까지 추출
a <- df_exam %>% select(id, math)
head(a)

df_exam %>% 
  select(id, math) %>%
  head(6)

### 순서 정렬
df_exam %>% arrange(math) # 오름차순
df_exam %>% arrange(desc(math)) # 내림차순

### 파생변수 추가
df_exam %>% 
  mutate(total = math + english + science) %>%
  head
df_exam

# 파생변수 여러 개 추가
df_exam %>% 
  mutate(total = math + english + science, 
         mean = (math + english + science)/3) %>%
  head

# mutate에 ifelse 적용
df_exam %>% 
  mutate(test = ifelse(science >= 60, 'pass', 'fail')) %>%
  head

# 추가 변수 활용
df_exam %>% 
  mutate(total = math + english + science) %>%
  arrange(total) %>%
  head

### 집단별로 요약

# 요약
df_exam %>% summarise(mean_math = mean(math)) # 수학 평균 산출

# 집단별로 요약 - 각 반의 수학 평균
df_exam %>% 
  group_by(class) %>%
  summarise(mean_math = mean(math))

# 여러가지 요약 통계량 한 번에 산출
df_exam %>%
  group_by(class) %>%
  summarise(mean_math = mean(math), #평균
            sum_math = sum(math), # 합계
            median_math = median(math), #중앙값
            stud = n()) # 학생 수
' 자주 사용하는 요약 통계량 함수
1. mean() : 평균
2. sd() : 표준 편차 (요소들의 퍼짐의 정도)
3. sum() : 합계
4. median() : 중앙값
5. min(), max() : 최소값, 최대값
6. n() : 빈도
'

# 각 집단별로 다시 잡단 나누기
' 제조사 별 구동 방식 별 도심 연비 평균이 궁금하다.'
mpg %>%
  group_by(manufacturer, drv) %>%
  summarise(mean_cty = mean(cty)) %>%
  head(20)

'제조사 별로  group_by
"suv" 자동차의  filter
도시 및 고속도로 통합 연비   mutate
평균을 구해서   summarise
내림차순으로 정렬하고,    arrange
1-5위 출력    head' 
mpg %>%
  group_by(manufacturer) %>%
  filter(class == "suv") %>%
  mutate(total = (cty + hwy)/2) %>%
  summarise(mean_total = mean(total)) %>%
  arrange(desc(mean_total)) %>%
  head(5)

### 데이터 합치기 (가로로 합치기, 세로로 합치기)
test1 <- data.frame(id = c(1, 2, 3, 4, 5),
                    mid = c(50, 60, 70, 80, 90))
test2 <- data.frame(id = c(1:5),
                    final = c(95, 85, 75, 65, 55))

total_test <- left_join(test1, test2, by="id") #id 기준으로 합쳐서 total에 할당
'by에 변수명 지정할 때 변수명 앞 뒤로 따옴표 붙여야함'

# 매칭 - 반 별 데이터에 담임선생님 이름 추가
name <- data.frame(class = c(1:5), 
                   teacher = c('kim', 'lee', 'park', 'choi', 'jung'))
df_exam_new <- df_exam
df_exam_new <- left_join(df_exam, name, by = "class")

### 세로로 합치기

# 데이터 생성
g_a <- data.frame(id = c(1:5),
                  score = c(60, 80, 70, 90,85))
g_b <- data.frame(id = c(6:10),
                  score = c(70, 80, 65, 36, 85))
'세로로 합치기는 두 데이터 변수명이 같아야 한다.'
group_all <- bind_rows(g_a, g_b)

#-------------------------------------------------------------------------

'데이터 정제 - 빠진 데이터(결측치), 이상한 데이터(이상치) 제거'
'
결측치(Missing Value)
1. 누락된 값, 비어있는 값
2. 함수에 적용할 수 없다 -> 분석 결과를 왜곡
3. 제거한 후 분석 실시
'

#  결측치 찾기 - is.na(데이터 프레임 명) 
df <- data.frame(s = c('M', 'F', NA, 'M', 'F'),
                 score = c(5,4,2,3,NA))
df

is.na(df) # 결측치의 위치에 TRUE 반환
table(is.na(df)) # 결측치의 빈도를 출력
table(is.na(df$score))

# 결측치를 포함한 상태로 분석
mean(df$score)

### 결측치 제거
# 결측치가 있는행을 제거
'
행을 제거하는 경우는 데이터의 크기에 여유가 있을 때만 사용하자.
'
df %>% filter(!is.na(score)) # score 변수에 NA 인 데이터만 빼고 출력

# 여러 변수 동시에 결측치 없는 데이터를 추출
df_nomiss <- df %>% filter(!is.na(score) & !is.na(s))
df_nomiss

# 결측치가 하나라도 있으면 제외
'분석에 필요한 데이터까지 손실될 위험이 있음.'
df_nomiss2 <- na.omit(df)
df_nomiss2

### 함수의 결측치 제외 기능
mean(df$score, na.rm=T)

### summarise na.rm 기능
exam <- df_exam
exam[c(3,8,15), 'math'] <- NA

# 평균 산출
exam %>% summarise(mean_math = mean(math, na.rm = T),
                   sum_math = sum(math, na.rm = T),
                   median_math = median(math, na.rm = T))

### 결측치 대체 - 다른값을 채워 넣는 것
'
대체법
1. 대표값(평균, 최빈값)으로 일괄 대체
2. 통계분석기법, 예측값 추정해서 대체
'

mean(exam$math, na.rm=T)
exam$math <- ifelse(is.na(exam$math), 56, exam$math)
table(is.na(exam$math))

'
이상치 (Outlier) - 정상 범주에서 크게 벗어난 값
'
# 이상치를 포함한 데이터 생성
out <- data.frame(s = c(1, 2, 1, 3, 2, 1),
                  score = c(5, 4, 3, 4, 2, 6))
out

# 이상치 확인
table(out$s)
table(out$score)

# 이상치 결측 처리
out$s <- ifelse(out$s == 3, NA, out$s)
out

out$score <- ifelse(out$score == 6, NA, out$score)
out

# 결측치 제외 분석
out %>%
  filter(!is.na(s) & !is.na(score)) %>%
  group_by(s) %>%
  summarise(mean_score = mean(score))

'
극단적인 값 (극단치)
1. 논리적 판단
2. 통계적 판단
'

mpg <- as.data.frame(ggplot2::mpg)
boxplot(mpg$hwy)
'
- 상자그림 해석법
1. 상자 아래 세로 점선 : 아래 수염 - 하위 0~25%에 해당하는 값
2. 상자 밑면 : 1 사분위수(Q1) - 하위 25%에 위치하는 값
3. 상자 내 굵은 선 : 중앙값 (2사분위수, Q2), - 50%에 위치하는 값
4. 상자 윗면 : 3 사분위수(Q3) - 하위 75%에 위치하는 값
5. 상자 위 세로 점선 : 윗 수염 - 하위 75~100%에 해당하는 값

6. 상자 밖 가로 선: 극단치 경계 - Q1, Q3 밖 1.5 IQR 내 최대값 
7. 상자 밖 점 표식 : 극단치 - Q1, Q3 밖 1.5 IQR를 벗어난 최대값

8. 1.5 IQR : 1사분위수와 3사분위수에 1.5를 곱한 값
'

# 상자그림 통계치 출력
boxplot(mpg$hwy)$stats
summary(mpg$hwy)
'
1번부터 5번까지 순서대로 최소값, 1사분위수, 2사분위수, 3사분위수, 최대값
'

# 12~37 벗어나면 NA 할당 - 극단 처리
mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy > 37, NA, mpg$hwy)

# 결측치 제외 분석
mpg %>%
  group_by(drv) %>%
  summarise(mean_hwy = mean(hwy, na.rm=T))

#------------------------------------------------------------

'R 에서 만들 수 있는 그래프 - ggplot2 패키지 심화'

'
- 2차원, 3차원 그래프
- 지도 그래프
- 네트워크 그래프
- 모션차트
- 인터랙티브 그래프
'

### ggplot2 의 레이어 구조
'
1단게: 배경 설정 (축)
2단계: 그래프 추가 (산점도, 선, 막대)
3단계: 설정 추가 (축 범위, 색, 표식)
'

### 산점도 :  데이터를 x축과 y축에 점으로 표현한 그래프

# 배경 설정
ggplot(data=mpg, aes(x=displ, y=hwy))

# 그래프 추가
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point()

# 설정 추가 (축 범위 조절)
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point() + xlim(2, 6)

ggplot(data=mpg, aes(x=displ, y=hwy)) + 
  geom_point() + 
  xlim(2, 6) + 
  ylim(10, 30)

'qplot() vs ggplot() 비교
1. qplot() :  전처리 단계 데이터 확인용, 문법 간단, 기능이 단순
2. ggplot() : 최종 보고용 - 색, 폰트, 크기 등 세부 조작 가능
'

### 평균 막대 그래프 :  집단의 평균값을 막대 길이로 표현한 그래프
mpg <- as.data.frame(ggplot2::mpg)

df_mpg <- mpg %>%
  group_by(drv) %>%
  summarise(mean_hwy = mean(hwy))
df_mpg

ggplot(data = df_mpg, aes(x=drv, y=mean_hwy)) + geom_col()

# 크기 순으로 정렬
ggplot(data = df_mpg, aes(x = reorder(drv, -mean_hwy), y=mean_hwy)) + geom_col()

### 빈도 막대 그래프 : 값의 개수(빈도)로 막대 길이를 표현한 그래프

# x축 범주 변수, y축 빈도
ggplot(data=mpg, aes(x=drv)) + geom_bar() #빈도

#x축 연속 변수, y축 빈도
ggplot(data=mpg, aes(x=hwy)) + geom_bar()

'
1. 평균 막대 그래프 : geom_col()
-> 데이터를 요약한 평균표를 먼저 만든 후 평균표를 이용해서 생성
2. 빈도 막대 그래프 : geom_bar()
-> 별도로 표를 만들지 않고 원자료를 이용해서 생성
'

df <- mpg %>%
  group_by(manufacturer) %>%
  filter(class=='suv') %>%
  mutate(tot = (cty + hwy)/2) %>%
  summarise(mean_tot = mean(tot)) %>%
  arrange(desc(mean_tot)) %>%
  head(5)

ggplot(data=df, aes(x=reorder(manufacturer, -mean_tot), 
                    y=mean_tot)) + geom_col()

'선 그래프 - 시간에 따라 달라지는 데이터 표현 그래프

시계열 데이터 : 일변 환율 처럼 일정 시간 간격을 두고 나열된 데이터'

'economics 데이터 : 미국의 경제 지표들을 월별로 나타낸 데이터이며, 
                    ggplot2 패키지 내부에 존재한다.'

e <- as.data.frame(ggplot2::economics)
ggplot(data = economics, aes(x=date, y=unemploy)) + geom_line()
ggplot(data = economics, aes(x=date, y=psavert)) + geom_line()

'상자 그림 - 집단 간 분포 차이 표현
-> 데이터의 분포(퍼져있는 형태)를 직사각형 상자 모양으로 표현'

ggplot(data = mpg, aes(x=drv, y=hwy)) + geom_boxplot()

#-------------------------------------------------------------------------

### color / fill
ggplot(data = mpg) + 
  geom_bar(mapping = aes(x=class, color=class)) # 막대 테두리 색


ggplot(data = mpg) + 
  geom_bar(mapping = aes(x=class, fill=class)) # 막대 색

ggplot(data = mpg) + 
  geom_bar(mapping = aes(x=class, fill=as.factor(year))) 

### position 인자 - 막대기 위치
ggplot(data = mpg) + 
  geom_bar(mapping = aes(x=class, fill=as.factor(year)), position = 'stack') 

ggplot(data = mpg) + 
  geom_bar(mapping = aes(x=class, fill=as.factor(year)), position = 'dodge', width = 0.6)

# alpha = 막대 투명도 0~1
ggplot(data = mpg) + 
  geom_bar(mapping = aes(x=class, fill=as.factor(year)), alpha=0.5, position = 'identity')

# fill = 비율
ggplot(data = mpg) + 
  geom_bar(mapping = aes(x=class, fill=as.factor(year)), position = 'fill')

### geom_bar() 함수들 - 꾸미기

w <- data.frame(year = c('2014', '2015', '2016', '2017', '2018'),
                dong = c(65, 66, 64, 68, 72))
ggplot(data = w, mapping = aes(x=year, y=dong)) +
  geom_bar(stat = 'identity')

# coord_catesian() 함수
ggplot(data = w, mapping = aes(x=year, y=dong)) + 
  geom_bar(mapping = aes(fill=year), stat = 'identity') +
  coord_cartesian(ylim = c(60, 70))

# geom_labe()
ggplot(data = w, mapping = aes(x=year, y=dong)) + 
  geom_bar(mapping = aes(fill=year), stat = 'identity') +
  geom_label(aes(label=dong), nudge_y = 1.0) +
  coord_cartesian(ylim = c(60, 75))

# labs()
ggplot(data = w, mapping = aes(x=year, y=dong)) + 
  geom_bar(mapping = aes(fill=year), stat = 'identity') +
  geom_label(aes(label=dong), nudge_y = 1.0) +
  coord_cartesian(ylim = c(60, 75)) +
  labs(
    title = '내가 만든 그래프',
    subtitle = '내가 만든 차트',
    caption = 'Welcome to Korea',
    x = 'Year',
    y = 'W of dong'
  )

# ggthemes 패키지 테마 함수
install.packages('ggthemes')
library(ggthemes)

ggplot(data = w, mapping = aes(x=year, y=dong)) + 
  geom_bar(mapping = aes(fill=year), stat = 'identity') +
  geom_label(aes(label=dong), nudge_y = 1.0) +
  coord_cartesian(ylim = c(60, 75)) +
  labs(
    title = '내가 만든 그래프',
    subtitle = '내가 만든 차트',
    caption = 'Welcome to Korea',
    x = 'Year',
    y = 'W of dong'
  ) + theme_wsj()

# 폰트
ggplot(data = w, mapping = aes(x=year, y=dong)) + 
  geom_bar(mapping = aes(fill=year), stat = 'identity') +
  geom_text(aes(label=year), vjust = 1.1, color='green',
            position = position_dodge(0.9), size = 5.5) +
  geom_label(aes(label=dong), nudge_y = 1.0) +
  coord_cartesian(ylim = c(60, 75)) +
  labs(
    title = '내가 만든 그래프',
    subtitle = '내가 만든 차트',
    caption = 'Welcome to Korea',
    x = 'Year',
    y = 'W of dong'
  ) + theme_wsj()

# 팔레트
ggplot(data = w, mapping = aes(x=year, y=dong)) + 
  geom_bar(mapping = aes(fill=year), stat = 'identity') +
  geom_text(aes(label=year), vjust = 1.1, color='white',
            position = position_dodge(0.9), size = 5.5) +
  scale_fill_brewer(palette = 'paired') +
  theme_minimal() +
  coord_cartesian(ylim = c(60, 75)) +
  labs(
    title = '내가 만든 그래프',
    subtitle = '내가 만든 차트',
    caption = 'Welcome to Korea',
    x = 'Year',
    y = 'W of dong'
  ) + theme_wsj()
