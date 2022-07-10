-- [실습1] 날짜/시간 데이터 다루기
-- 현재 시간 조회하는 방법
SELECT NOW();

-- 현재시간보다 하루 전 날짜 구하는 방법
SELECT NOW(), NOW()::DATE - '1 DAY'::INTERVAL;

-- 현재 타임존 조회하는 방법
SHOW TIMEZONE;

-- 시스템 일자를 조회하는 방법
SELECT CURRENT_DATE, CURRENT_TIME, TIMEOFDAY();

SELECT NOW(), CURRENT_TIMESTAMP, TIMESTAMP 'NOW';

-- 날짜에서 연도를 추출하는 방법
SELECT DATE_PART('YEAR', TIMESTAMP '2020-07-30 20:38:40');
SELECT DATE_PART('YEAR', CURRENT_TIMESTAMP);

SELECT EXTRACT('ISOYEAR' FROM DATE '2006-01-01');
SELECT EXTRACT('ISOYEAR' FROM CURRENT_TIMESTAMP);

SELECT DATE_TRUNC('YEAR', TIMESTAMP '2020-07-30 20:38:40');
SELECT DATE_TRUNC('YEAR', CURRENT_TIMESTAMP);

-- 날짜에서 월을 추출하는 방법
SELECT DATE_PART('MONTH', TIMESTAMP '2020-07-30 20:38:40');
SELECT DATE_PART('MONTH', CURRENT_TIMESTAMP);

SELECT EXTRACT('MONTH' FROM TIMESTAMP '2020-07-30 20:38:40');
SELECT EXTRACT('MONTH' FROM INTERVAL '2 YEARS 3MONTHS');
SELECT EXTRACT('MONTH' FROM INTERVAL '2 YEARS 13MONTHS');

SELECT DATE_TRUNC('MONTH', TIMESTAMP '2020-07-30 20:38:40');

-- 날짜에서 일을 추출하는 방법
SELECT DATE_PART('DAY', TIMESTAMP '2020-07-30 20:38:40');
SELECT DATE_TRUNC('DAY', TIMESTAMP '2020-07-30 20:38:40');

-- 시간에서 시를 추출하는 방법
SELECT DATE_PART('HOUR', TIMESTAMP '2013-07-30 20:38:40');
SELECT DATE_PART('HOUR', INTERVAL '4 HOURS 3 MINUTES');
SELECT DATE_TRUNC('HOUR', TIMESTAMP '2020-07-30 20:38:40');

-- 시간에서 분을 추출하는 방법
SELECT DATE_PART('MINUTE', TIMESTAMP '2020-07-30 20:38:40');
SELECT DATE_TRUNC('MINUTE', TIMESTAMP '2020-07-30 20:38:40');

-- 시간에서 초를 추출하는 방법
SELECT DATE_PART('SECOND', TIMESTAMP '2013-07-30 20:38:40');
SELECT EXTRACT('SECOND' FROM TIME '17:12:28.5');
SELECT DATE_TRUNC('SECOND', TIMESTAMP '2013-07-30 20:38:40');


-- [실습2-1] 변환함수
-- 주수 구하기
SELECT EMP_NAME, TO_CHAR((CURRENT_TIMESTAMP - ENT_DATE), 'W') WEEKS
FROM cslee.TB_EMP
WHERE ORG_CD = '10';

-- TO_CHAR 구문
SELECT EMP_NAME, ENT_DATE,
		TO_CHAR(ENT_DATE, 'YYYY') 입사년,
		TO_CHAR(ENT_DATE, 'MM') 입사월,
		TO_CHAR(ENT_DATE, 'DD') 입사일
FROM cslee.TB_EMP;

-- EXTRACT 구문
SELECT EMP_NAME, ENT_DATE,
EXTRACT('YEAR' FROM ENT_DATE) 입사년,
EXTRACT('MONTH' FROM ENT_DATE) 입사월,
EXTRACT('DAY' FROM ENT_DATE) 입사일
FROM cslee.TB_EMP;

-- 변환함수(명시적 데이터 유형 변환) TO_DATE, TO_NUMBER, TO_TIMESTAMP, CAST
SELECT TO_DATE('05 DEC 2000', 'DD MON YYYY');

SELECT TO_NUMBER('12,454.8-', '99G999D9S');

SELECT TO_TIMESTAMP('05 DEC 2000', 'DD MON YYYY');

-- 변환함수 전체 예제
SELECT CAST(123.4 AS VARCHAR(10)),
	   CAST('123.5' AS NUMERIC),
	   CAST(1234.5678 AS DEC(6, 2)),
	   CAST(CURRENT_TIMESTAMP AS DATE),
	   TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS'),
	   TO_CHAR(1234.56, 'L9,999.99'),
	   TO_NUMBER('$12,345', '$99,999'),
	   TO_DATE('2014/03/01 21:30:18', 'YYYY/MM/DD HH24:MI:SS'),
	   TO_TIMESTAMP('2014/03/01 21:30:18', 'YYYY/MM/DD HH24:MI:SS');

	  
-- [실습2-2] CASE
-- CASE 표현 예제
SELECT EMP_NAME,
	CASE WHEN SALARY > 50000000
	THEN SALARY
	ELSE 50000000
	END AS REVISED_SALARY
FROM cslee.TB_EMP;

-- 교재 p.159 실습
SELECT ORG_NAME,
CASE ORG_NAME
WHEN '영업1팀' THEN '지사'
WHEN '영업2팀' THEN '지사'
WHEN '영업3팀' THEN '지사'
WHEN '경영관리팀' THEN '본사'
ELSE '지점'
END AS AREA
FROM cslee.TB_ORG;

-- 교재 p.160
-- CASE문
SELECT EMP_NAME,
	CASE WHEN SALARY >= 90000000 THEN 'HIGH'
		 WHEN SALARY >= 60000000 THEN 'MID'
		 ELSE 'LOW'
	END AS SALARY_GRADE
FROM cslee.TB_EMP;

-- 중첩 CASE문
SELECT EMP_NAME, SALARY,
	CASE WHEN SALARY >= 50000000 THEN 20000000
		ELSE (CASE WHEN SALARY >= 20000000 THEN 10000000
					ELSE SALARY * 0.5
			  END)
	END AS BONUS
FROM cslee.TB_EMP;


-- [실습2-3] NULL 관련 함수
-- COALESCE 함수
SELECT EMP_NAME, POSITION,
	COALESCE(POSITION, '없음')
FROM cslee.TB_EMP;

-- CASE 함수
SELECT EMP_NAME, POSITION,
CASE WHEN POSITION IS NULL THEN '없음'
	 ELSE POSITION
END AS 직책
FROM cslee.TB_EMP;

-- NULL과 공집합
SELECT COALESCE(SALARY, 0) SAL
FROM cslee.TB_EMP
WHERE EMP_NAME = '김태진';

SELECT MAX(SALARY) SAL
FROM cslee.TB_EMP
WHERE EMP_NAME = '김태진';

SELECT COALESCE(MAX(SALARY), 9999) SAL
FROM cslee.TB_EMP
WHERE EMP_NAME = '김태진';

-- [실습3-1] 집계함수, GROUP BY
-- p.167
SELECT COUNT(*) "전체건수",
	COUNT(POSITION) "직책건수",
	COUNT(DISTINCT POSITION) "직책종류",
	MAX(SALARY) "최대",
	MIN(SALARY) "최소",
	AVG(SALARY) "평균"
FROM cslee.TB_EMP;

-- GROUP BY 절
-- p.169
SELECT POSITION "직책",
COUNT(*) "인원수",
MIN(SALARY) "최소",
MAX(SALARY) "최대",
AVG(SALARY) "평균"
FROM cslee.TB_EMP
GROUP BY POSITION;

-- [실습3-2] HAVING 절
-- HAVING 절
SELECT ORG_CD "부서",
COUNT(*) "인원수",
AVG(SALARY) "평균"
FROM cslee.TB_EMP
GROUP BY ORG_CD 
HAVING COUNT(*) >= 4;

SELECT ORG_CD "부서",
MAX(SALARY) "최대"
FROM cslee.TB_EMP
GROUP BY ORG_CD
HAVING MIN(SALARY) <= 40000000;

SELECT ORG_CD, POSITION, AVG(SALARY)
FROM cslee.TB_EMP
WHERE POSITION IN ('과장', '대리', '사원')
GROUP BY ORG_CD, POSITION;

-- [실습3-3] 고급 집계쿼리
SELECT ORG_CD,
	AVG(CASE POSITION WHEN '과장' THEN SALARY END) "과장",
	AVG(CASE POSITION WHEN '대리' THEN SALARY END) "대리",
	AVG(CASE POSITION WHEN '사원' THEN SALARY END) "사원"
FROM cslee.TB_EMP
WHERE POSITION IN ('과장', '대리', '사원')
GROUP BY ORG_CD;

SELECT ORG_CD,
SUM(COALESCE((CASE POSITION WHEN '팀장' THEN 1 ELSE 0 END),0)) "팀장",
SUM(COALESCE((CASE POSITION WHEN '과장' THEN 1 ELSE 0 END), 0)) "과장",
SUM(COALESCE((CASE POSITION WHEN '대리' THEN 1 ELSE 0 END), 0)) "대리",
SUM(COALESCE((CASE POSITION WHEN '사원' THEN 1 ELSE 0 END), 0)) "사원"
FROM cslee.TB_EMP
GROUP BY ORG_CD;

SELECT ORG_CD,
COALESCE(SUM(CASE POSITION WHEN '팀장' THEN 1 ELSE 0 END),0) "팀장",
COALESCE(SUM(CASE POSITION WHEN '과장' THEN 1 ELSE 0 END),0) "과장",
COALESCE(SUM(CASE POSITION WHEN '대리' THEN 1 ELSE 0 END),0) "대리",
COALESCE(SUM(CASE POSITION WHEN '사원' THEN 1 ELSE 0 END),0) "사원"
FROM cslee.TB_EMP
GROUP BY ORG_CD;

-- [실습4-1] EQUI JOIN 실습
-- [예제] 사원 테이블과 조직 테이블의 조인 SQL
SELECT TB_EMP.EMP_NAME, TB_EMP.ORG_CD,
		TB_ORG.ORG_CD, TB_ORG.ORG_NAME
FROM cslee.TB_EMP, cslee.TB_ORG
WHERE cslee.TB_EMP.ORG_CD = cslee.TB_ORG.ORG_CD;

-- [예제] 사원이름, 소속부서코드, 부서명(조직명), 직책 출력
SELECT TB_EMP.EMP_NO, TB_EMP.EMP_NAME,
		TB_ORG.ORG_NAME, TB_EMP.POSITION
FROM cslee.TB_EMP, cslee.TB_ORG
WHERE cslee.TB_EMP.ORG_CD = cslee.TB_ORG.ORG_CD;

-- ALIAS 사용
SELECT E.EMP_NO, E.EMP_NAME, E.ORG_CD,
		O.ORG_NAME, E.POSITION
FROM cslee.TB_EMP AS E,
	 cslee.TB_ORG AS O
WHERE E.ORG_CD = O.ORG_CD
AND E.POSITION = '팀장'
ORDER BY O.ORG_NAME;

-- [실습4-2] 3개 이상 테이블 조인
-- [예제] 계좌번호, 고객명, 상품명, 계약금액, 관리자명 출력
SELECT A.ACCNO, C.CUST_NAME, P.PROD_NAME,
		A.CONT_AMT, E.EMP_NAME
FROM cslee.TB_ACCNT A,
	 cslee.TB_CUST C,
	 cslee.TB_PROD P,
	 cslee.TB_EMP E 
WHERE A.CUST_NO = C.CUST_NO 
AND A.PROD_CD = P.PROD_CD
AND A.MANAGER = E.EMP_NO;

-- [예제] 사원별 급여와 어느 등급에 속하는지 알고 싶다는 요구사항에 대한 NON EQUI JOIN
SELECT E.EMP_NAME 사원명,
		E.SALARY 연봉,
		S.GRADE 급여등급
FROM cslee.TB_EMP E, cslee.TB_GRADE S 
WHERE E.SALARY BETWEEN S.LOW_SAL AND S.HIGH_SAL;

-- [실습4-3] 표준조인
-- [예제] 사원 번호와 사원 이름, 소속부서 코드와 소속부서 이름 찾아보기
-- (1) WHERE 절 JOIN 조건
SELECT EMP.EMP_NO, EMP.EMP_NAME, ORG.ORG_NAME
FROM cslee.TB_EMP EMP, cslee.TB_ORG ORG
WHERE EMP.ORG_CD = ORG.ORG_CD;

-- (2) FROM 절 JOIN 조건
SELECT EMP.EMP_NO, EMP.EMP_NAME, ORG.ORG_NAME
FROM cslee.TB_EMP EMP 
INNER JOIN cslee.TB_ORG ORG 
ON EMP.ORG_CD = ORG.ORG_CD;

-- (3) INNER 키워드 생략
SELECT EMP.EMP_NO, EMP.EMP_NAME, ORG.ORG_NAME
FROM cslee.TB_EMP EMP 
JOIN cslee.TB_ORG ORG 
ON EMP.ORG_CD = ORG.ORG_CD;

-- [예제] 계좌 테이블에서 계좌번호, 고객번호, 고객명을 고객테이블과 초인하여 찾아보기
SELECT ACC.ACCNO, ACC.CUST_NO, CUST.CUST_NAME
FROM cslee.TB_ACCNT ACC 
INNER JOIN cslee.TB_CUST CUST 
ON (CUST.CUST_NO = ACC.CUST_NO);

-- [예제] 조직코드 10인 부서의 소속 사원 이름 및 소속 부서 코드, 부서 코드, 부서 이름 찾아보기
SELECT E.EMP_NAME, E.ORG_CD, O.ORG_CD, O.ORG_NAME
FROM cslee.TB_EMP E 
JOIN cslee.TB_ORG O 
ON (E.ORG_CD = O.ORG_CD)
WHERE E.ORG_CD = '10';

-- ON 조건절 - 다중조인
-- (1) WHERE 절 JOIN 조건
SELECT A.ACCNO 계좌번호, C.CUST_NAME 고객명, P.PROD_NAME 상품명,
		A.CONT_AMT 계약금액, E.EMP_NAME 담당자명
FROM cslee.TB_ACCNT A, cslee.TB_CUST C, cslee.TB_PROD P, cslee.TB_EMP E 
WHERE A.CUST_NO = C.CUST_NO 
AND A.PROD_CD = P.PROD_CD 
AND A.MANAGER = E.EMP_NO;

-- (2) ON 절 JOIN 조건
SELECT A.ACCNO 계좌번호, C.CUST_NAME 고객명, P.PROD_NAME 상품명,
		A.CONT_AMT 계약번호, E.EMP_NAME 담당자명
FROM cslee.TB_ACCNT A
INNER JOIN cslee.TB_CUST C ON A.CUST_NO = C.CUST_NO 
INNER JOIN cslee.TB_PROD P ON A.PROD_CD = P.PROD_CD 
INNER JOIN cslee.TB_EMP E ON A.MANAGER = E.EMP_NO;

-- CROSS 조인
SELECT COUNT(EMP_NAME) FROM cslee.TB_EMP;
SELECT COUNT(ORG_NAME) FROM cslee.TB_ORG;

SELECT E.EMP_NAME, O.ORG_NAME
FROM cslee.TB_EMP E CROSS JOIN cslee.TB_ORG O 
ORDER BY EMP_NAME;

SELECT COUNT(E.EMP_NAME)
FROM cslee.TB_EMP E CROSS JOIN cslee.TB_ORG O;

-- LEFT OUTER JOIN
-- [예제] 직원 중에 아직 부서배정이 안 된 사원도 있다. 
-- 사원과 조직을 JOIN하되 부서배정이 안 된 사원의 정보도 같이 출력
SELECT E.EMP_NO 사번, E.EMP_NAME 사원명,
		E.POSITION 직책, O.ORG_NAME 부서명
FROM cslee.TB_EMP E LEFT OUTER JOIN cslee.TB_ORG O 
	ON E.ORG_CD = O.ORG_CD 
WHERE E.POSITION = '사원';


-- RIGHT OUTER JOIN
-- [예제] 이전 예제에서 LEFT JOIN을 OUTER JOIN으로 표현
SELECT E.EMP_NO 사번, E.EMP_NAME 사원명, 
		E.POSITION 직책, O.ORG_NAME 부서명
FROM cslee.TB_ORG O RIGHT OUTER JOIN cslee.TB_EMP E
	ON E.ORG_CD = O.ORG_CD 
WHERE E.POSITION = '사원';

-- FULL OUTER JOIN
SELECT A.ORG_CD, A.ORG_NAME, B.ORG_CD, B.ORG_NAME
FROM cslee.TB_ORG A FULL OUTER JOIN cslee.TB_ORG B 
ON A.ORG_CD = B.ORG_CD;

SELECT A.ORG_CD, A.ORG_NAME, B.ORG_CD, B.ORG_NAME
FROM cslee.TB_ORG A LEFT OUTER JOIN cslee.TB_ORG B 
ON A.ORG_CD = B.ORG_CD 
UNION 
SELECT A.ORG_CD, A.ORG_NAME, B.ORG_CD, B.ORG_NAME 
FROM cslee.TB_ORG A RIGHT OUTER JOIN cslee.TB_ORG B 
ON A.ORG_CD = B.ORG_CD;
