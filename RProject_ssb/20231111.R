' --REVIEW--

- 데이터 파악 함수
1. head() : 데이터 앞부분
2. tail() : 데이터 뒷 부분
3. View() : 뷰어 창 데이터 확인
4. dim() : 데이터의 차원을 출력
5. str() : 데이터의 속성을 출력
6. summary() : 요약 통계량

- 데이터 가공 함수 -> 전처리 함수
1. filter() : 행 추출 함수
2. select() : 열 추출 함수 -> 변수 추출 함수
3. arrange() : 정렬
4. mutate() : 변수 추가
5. summarise() : 통계치 산출
6. group by() : 집단별로 나누기
7. left_join() : 데이터 합치기(열 기준)
8. bind_rows() : 데이터 합치기(행 기준)

- 결측치
1. 누락되거나 비어있는 값
2. 함수에 적용 x, 분석 결과를 왜곡
3. 제거 한 후에 분석을 실행
-> 대표값으로 대체, 통계 분석 기법을 활용해서 대체

- 이상치
1. 정상 범주에서 크게 벗어난 값

- 극단치
1. 논리 :  성인 몸무게 30~150 벗어나면 극단적인 값으로 간주
2. 통계 : 상하위 0.3% 극단치 또는 상자그림 1.5IQR 벗어나면 극단치로 간주

- ggplot() : R에서 그래프를 그릴때(시각화) 쓰는 패키지
'

#------------------------------------------------------------

'한국복지패널데이터 분석'
'한국보건사회연구원에서 가구의 경제활동을 연구해서 정책지원에
반영할 목적으로 발간하는 조사자료,
2006~2015년까지 7천여 가구를 추적 조사한 자료'

### Using Packages
'foreign 패키지 : SPSS, SAS, STATA 등 통계 분석 소프트웨서의 파일을 불러올 때'

install.packages('foreign')

library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

### 데이터 로드
raw_welfare <- read.spss(file='Koweps_hpc10_2015_beta1.sav',
                         to.data.frame = T)
raw_welfare

# 변수명 변경
welfare <- rename(raw_welfare,
                  sex = h10_g3,
                  birth = h10_g4,
                  marriage = h10_g10,
                  religion = h10_g11,
                  income = p1002_8aq1,
                  code_job = h10_eco9,
                  code_region = h10_reg7)
welfare$birth
'
- 데이터 분석 절차
1. 변수 검토 및 전처리
-> 변수의 특성 파악하고 이상치를 정제한 다음 파생변수 생성

2. 변수간에 관계 분석
-> 요약표, 그래프 찍는다
'

'성별에 따른 월급 차이 - 성별에 따라 월급이 다를까?'
'가설 -> 성별에 따라 월급 차이가 있을 것이다.'
# 이상치 확인
table(welfare$sex) 
# 결측치 확인
table(is.na(welfare$sex))
# 월급 변수 검토 전처리
class(welfare$income)
summary(welfare$income)
qplot(welfare$income) + xlim(0, 1000)

# 이상치 확인 후 처리
welfare$income <- ifelse(welfare$income %in% c(0,9999), NA, welfare$income)

# 결측치 확인
table(is.na(welfare$income))

### 성별 월급 평균표 생성
sex_income <- welfare %>%
              filter(!is.na(income)) %>%
              group_by(sex) %>%
              summarise(mean_income = mean(income))
sex_income

ggplot(data=sex_income, aes(x=sex, y=mean_income)) + geom_col()


'나이와 월급의 관계'
## 나이 변수 검토
summary(welfare$birth) #이상치 확인

# 결측치 확인
table(is.na(welfare$birth))

# 파생변수 '나이' 생성
welfare$age <- 2015 - welfare$birth + 1
summary(welfare$age)
qplot(welfare$age)

### 나이와 월급 관계 분석
age_income <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(age) %>%
  summarise(mean_income = mean(income))
age_income

# 그래프 생성 -> 시각화
ggplot(data = age_income, aes(x=age, y=mean_income)) + geom_line()

'연령대에 따른 월급 차이'
# 연령대라는 변수를 만들어야함
# 초년 -> 30세 미만, 중년 -> 30-59세, 노년 -> 60세 이상
welfare <- welfare %>%
  mutate(ageg = ifelse(age < 30, 'young', 
                       ifelse(age <= 59, 'middle','old')))
table(welfare$ageg)

ageg_income <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(ageg) %>%
  summarise(mean_income = mean(income))
ageg_income

ggplot(data = ageg_income, aes(x=ageg, y=mean_income)) + geom_col()

# x 축 순서를 직접 지정
ggplot(data = ageg_income, aes(x=ageg, y=mean_income)) +
  geom_col() +
  scale_x_discrete(limits = c('young', 'middle', 'old'))


'연령대 및 성별 월급 차이 - 성별월급차이는 연령대별로 다를까?'
s_income <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(ageg, sex) %>%
  summarise(mean_income = mean(income))
s_income

ggplot(data = s_income, aes(x=ageg, y=mean_income, fill=sex)) +
  geom_col() +
  scale_x_discrete(limits = c('young', 'middle', 'old'))

# 막대그래프 성별 나누기
ggplot(data = s_income, aes(x=ageg, y=mean_income, fill=sex)) +
  geom_col(position = 'dodge2') +
  scale_x_discrete(limits = c('young', 'middle', 'old'))

'나이 및 성별 월급 차이 분석 (선그래프)'

# 성별 연령별 월급 평균표
s_age <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(age, sex) %>%
  summarise(mean_income = mean(income))
s_age

ggplot(data = s_age, aes(x=age, y=mean_income, col=sex)) +
  geom_line()

'직업별 월급 차이 - 어떤 직업이 월급을 가장 많이 받는지'

## 직업 변수 검토
class(welfare$code_job)
table(welfare$code_job)

## 전처리
library(readxl)
list_job <- read_excel('Koweps_Codebook.xlsx', col_names = T, sheet=2)
list_job

welfare <- left_join(welfare, list_job, by='code_job')

# 직업 월급 평균표 생성
job_income <- welfare %>%
  filter(!is.na(job) & !is.na(income)) %>%
  group_by(job) %>%
  summarise(mean_income = mean(income))

# 월급이 높은 직업 top10
top10 <- job_income %>%
  arrange(desc(mean_income)) %>%
  head(10)
top10

# 그래프 생성
ggplot(data = top10, aes(x=reorder(job, mean_income), y=mean_income, fill=job)) + 
  geom_col() +
  coord_flip() #막대를 오른쪽으로 90도 회전

# 월급이 낮은 직업10 추출
bottom10 <- job_income %>%
  arrange(mean_income) %>%
  head(10)
bottom10

ggplot(data = bottom10, aes(x=reorder(job, -mean_income), y=mean_income)) + 
  geom_col() +
  coord_flip() +
  ylim(0, 800)

'성별 직업 빈도 - 성별로 어떤 직업이 가장 많은지'

# 성별 직업 빈도표
job_male <- welfare %>%
  filter(!is.na(job) & sex==1) %>%
  group_by(job) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  head(10)
job_male

job_female <- welfare %>%
  filter(!is.na(job) & sex==2) %>%
  group_by(job) %>%
  summarise(n=n()) %>%
  arrange(desc(n)) %>%
  head(10)
job_female

## 그래프 생성
# 남성
ggplot(data = job_male, aes(x=reorder(job, n), y=n)) +
  geom_col() + 
  coord_flip()
# 여성
ggplot(data = job_female, aes(x=reorder(job, n), y=n)) +
  geom_col() +
  coord_flip()


'종교 유무에 따른 이혼율 분석'
# 변수 검토
table(welfare$marriage)
table(welfare$religion)

# 종교 유무에 이름 부여
welfare$religion <- ifelse(welfare$religion == 1, 'yes', 'no')
table(welfare$religion)

# 파생변수 '이혼여부' 생성
welfare$group_marriage <- ifelse(welfare$marriage == 1, 'marriage',
                                 ifelse(welfare$marriage == 3, 'divorce',
                                        NA))
table(welfare$group_marriage)

# 종교 유무에 따른 이혼율 분석
religion_marriage <- welfare %>%
  filter(!is.na(group_marriage)) %>%
  group_by(religion, group_marriage) %>%
  summarise(n = n()) %>%
  mutate(total_group = sum(n)) %>%
  mutate(pct = round(n/total_group*100,1))
religion_marriage

# 이혼만 추출
divorce <- religion_marriage %>%
  filter(group_marriage == 'divorce') %>%
  select(religion, pct)
divorce

#---------------------------------------------------------

'인터렉티브 그래프 : 마우스 움직임에 반응해서 실시간으로 형태가 변하는 그래프'
'그래프를 HTML 포맷으로 저장하면 일반 사용자들도 웹 브라우저를 이용해서 자유롭게 조작하며 볼수 있음'

install.packages('plotly')
library(plotly)

p <- ggplot(data = mpg, aes(x=displ, y=hwy, col=drv)) +
  geom_point()
ggplotly(p)

### 인터렉티브 막대 그래프
p <- ggplot(data = diamonds, aes(x=cut, fill=clarity)) +
  geom_bar(position = 'dodge') 
ggplotly(p)

### dygraphs 패키지로 인터렉티브 시계열 그래프 생성
install.packages('dygraphs')
library('dygraphs')
library(xts)

head(economics)

'해당 패키지로 시계열 그래프를 만들려면 데이터 시간 순서의
속성을 지니는 xts 데이터 타입으로 변경을 해야한다.'
'-> xts()'

eco <- xts(economics$unemploy, order.by = economics$date)
dygraph(eco)

# 날짜 범위 선택 기능 추가
dygraph(eco) %>% dyRangeSelector()

# 여러 개 값 표시하기
economics
eco_a <- xts(economics$psavert, order.by = economics$date)
eco_b <- xts(economics$unemploy/1000, order.by = economics$date)

# cbind()를 사용해서 가로로 결합 후 변수명 수정
eco2 <- cbind(eco_a, eco_b) # 데이터 결합
colnames(eco2) <- c('psavert', 'unemploy')
head(eco2)

dygraph(eco2) %>% dyRangeSelector()


#--------------------------------------------------------

'지도 시각화'
'단계 구분도 : 지열별 통계치를 색깔의 차이로 표현한 지도'

### 패키지 로드
install.packages('ggiraphExtra')
library(ggiraphExtra)

### 미국 주별 범죄 데이터 로드
'USArrests Data : R 언어에 기본적으로 내장되어 있는 1970년도
미국 주 별 강력 범죄율 정보를 담고 있는 데이터'
str(USArrests)
head(USArrests)

'tibble 패키지 rownames_to_column()를 사용해서
행 이름을 state변수로 바꿔서 새로운 데이터 프레임을 만들어준다.'

'tolower() : 소문자 변환 함수'

library(tibble)

crime <- rownames_to_column(USArrests, var = 'state')
crime$state <- tolower(crime$state)
str(crime)

### 미국 주 지도 데이터 로드
'단계 구분도 만들려면 위도, 경도 정보가 있는 지도 데이터가 필요'

'maps 패키지에 미국 주 별 위경도를 나타낸 state데이터가 있음'
'-> 해당 데이터를 ggplot2의 map_data() 함수를 사용해 DF 형태로 가져옴'
states_map <- map_data('state')
str(states_map)

### 단계 구분도 생성
ggChoropleth(data = crime, #지도에 표현할 데이터
             aes(fill=Murder, #색깔로 표현할 변수
                  map_id=state), #지역 기준 변수
             map = states_map) #지도 데이터

### 인터렉티브 단계 구분도 생성
ggChoropleth(data = crime,
             aes(fill=Murder, map_id=state),
             map = states_map,
             interactive = T) #인터렉티브 여부

'kormaps2014 패키미 : 대한민국의 지역 통계 데이터와 지도 데이터를 사용하게 해줌'
install.packages('stringi')
install.packages('devtools')
devtools::install_github('cardiomoon/kormaps2014')
library(kormaps2014)

### 데이터 로드
'korpop1 : 2015년 센서스 데이터(시도별)
 korpop2 : 2015년 센서스 데이터(시구군별)
 korpop3 : 2015년 센서스 데이터(읍면동별)'

str(korpop1)

# 변수명 수정
library(dplyr)
korpop1 <- rename(korpop1,
                  pop = '총인구_명',
                  name = '행정구역별_읍면동')

# 대한민국 시도 지도 데이터 확인
str(kormap1)

### 단계 구분도 생성
library(ggplot2)
library(ggiraphExtra)
library(tibble)
ggChoropleth(data = korpop1, #지도에 표현할 데이터
              aes(fill=pop, #색깔로 표현할 변수
                  map_id=code, #지역 기준 변수
                  tooltip=name), #지도 위에 표시할 지역명)
             map = kormap1, #지도 데이터
             interactive = T) #인터렉티브 여부

### 시도별 결핵 환자 수 단계 구분도
'tbc 데이터 : 지역별 결핵 환자 수 데이터
  -> NewPts(결핵 환자수) 변수 사용'

str(tbc)

ggChoropleth(data = tbc,
             aes(fill=NewPts,
                 map_id=code,
                 tooltips=name),
             map = kormap1,
             interactive = T)

#-------------------------------------------------
'텍스트 마이닝 : 문자로 된 데이터에서 가치 있는 정도를 얻어 내는 기법'

'형태소 분석 : 문장을 구성하는 어절들이 어떤 품사로 되어 있는지 파악하는 작업'