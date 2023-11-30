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
  scale_x_discrete(limit = c('young', 'middle', 'old'))

# 막대그래프 성별 나누기
ggplot(data = s_income, aes(x=ageg, y=mean_income, fill=sex)) +
  geom_col(position='dodge2') + 
  scale_x_discrete(limit = c('young', 'middle', 'old'))
