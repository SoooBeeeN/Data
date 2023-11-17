###벡터

#숫자형 벡터
ex_vector1 <- c(-1, 0, 1)
ex_vector1 # 변수 조회

#속성값 확인 함수들
mode(ex_vector1) # 데이터 유형 확인 함수
str(ex_vector1) # 데이터 유형, 값 한번에 확인
length(ex_vector1)  # 데이터 길이 확인 함수

#str()
str(12345)
mode(12345)
str('hello world') #chr : 문자열 자료형
str('18')
str(TRUE) #logi : 논리형 자료형

# 문자형 벡터 : 문자로 이루어진 데이터
"R에서 문자열 : 작음따옴표나 큰따옴표로 감싸서 표현"
ex_vector2 <- c("Hello", "Hi~!")
ex_vector2
ex_vector3 <- c('1', '2','3')
ex_vector3

str(ex_vector3)

# 논리형 벡터 : TRUE, FALSE 데이터를 비교할 때 사용
ex_vector4 <- c(TRUE, FALSE, TRUE, FALSE)
ex_vector4
str(ex_vector4)

# 범주형 자료 : 숫자를 포함하지만 계산X 자료형
'factor() 사용해 범주형 자료 생성'

ex_vector5 <- c(2, 1, 3, 2, 1)
ex_vector5

cate_vector5 <- factor(ex_vector5, labels=c('Apple', 'Banana', "Cherry"))
cate_vector5
str(cate_vector5)
mode(cate_vector5)


### 행렬 (행 : row, 열 :  column)
x <- c(1,2, 3, 4, 5,6)
matrix(x, nrow = 2, ncol = 3)
matrix(x, nrow = 3, ncol = 2)

### 배열(array() 함수)
y <- c(1, 2, 3, 4, 5, 6)
array(y, dim=c(2, 2, 3))

### 리스트 (1차원이며 다중형 데이터인 데이터 세트)
list1 <- list(c(1, 2, 3), 'Hello')
list1

'데이터 프레임의 각 열의 이름은 "변수명"으로 말한다.'

ID <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
SEX <- c("F", "M", "F", "M", "M", "F", "F", "F", "M", "F")
AGE <- c(50, 40, 28, 50, 27, 23, 56, 47, 20, 38)
AREA <- c('서울', "경기", "제주", '서울', '서울',
          '서울', '경기', '서울', '인천', '경기')
dataframe_ex <- data.frame(ID, SEX, AGE, AREA)

dataframe_ex
