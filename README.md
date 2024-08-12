# PublicWifi
### 공공 와이파이 검색 서비스
![최종발표-010](https://github.com/user-attachments/assets/d18ecd85-6be4-4c50-93e0-fd8189f20ee0)

## 프로젝트 개요

이 프로젝트는 사용자의 현재 위치를 기반으로 주변의 공공 와이파이 정보를 지도에 표시해주는 iOS 애플리케이션입니다. 사용자는 시/도와 시/군/구를 선택하여 해당 지역의 공공 와이파이 정보를 확인할 수 있습니다.

## 주요 기능

1. 사용자 현재 위치 기반 지도 표시
2. 시/도 및 시/군/구 선택을 통한 공공 와이파이 정보 검색
3. 선택된 공공 와이파이 위치를 지도에 표시

## 기술 스택

- 프로그래밍 언어: Swift
- 데이터베이스: SQLite3
- 지도 서비스: MapKit
- UI 디자인: Figma

## 구현 과정

### 1. UI/UX 설계
![Untitled](https://github.com/user-attachments/assets/2c8f5648-fb29-415f-bea5-df6ebdf0bd3f)

- Figma를 사용하여 애플리케이션의 전체적인 레이아웃과 사용자 흐름 설계

### 2. 공공 와이파이 데이터베이스 구축
![Untitled (1)](https://github.com/user-attachments/assets/b44e6641-7265-408a-9336-1f4db44c6a37)
![Untitled (5)](https://github.com/user-attachments/assets/dc356eb7-459e-4d48-a8ea-d723626887fd)


- 공공 데이터 포털에서 제공하는 공공 와이파이 엑셀 파일을 CSV로 변환
- CSV 파일을 SQLite3 데이터베이스로 변환

### 3. 위치 기반 서비스 구현
<img src="https://github.com/user-attachments/assets/3e6b4cf8-0919-4943-b313-6dd6952bef74" alt="위치 기반 서비스" width="20%">

사용자 위치 권한 요청 및 현재 위치 트래킹 기능 구현
MapKit을 사용하여 사용자 현재 위치를 지도에 표시

### 4. 데이터베이스 쿼리 및 정보 표시

다음과 같은 SQL 쿼리를 사용하여 데이터 검색:
```sql
SELECT state FROM wifiList GROUP BY state ORDER BY state
SELECT * FROM wifiList WHERE state = '서울특별시' GROUP BY city ORDER BY city
SELECT * FROM wifiList WHERE city = '가평군'
```
<img src="https://github.com/user-attachments/assets/beaa2155-845b-4a0e-9bcf-b395631987ff" alt="데이터베이스 쿼리 결과" width="20%">

- 사용자가 선택한 지역의 공공 와이파이 정보를 리스트 형태로 표시
- 선택된 공공 와이파이 위치를 지도에 마커로 표시

<img src="https://github.com/user-attachments/assets/baa4648f-0dce-4ef9-9180-6ce243ad9512" alt="지도에 마커 표시" width="20%">

## 프로젝트 의의

- 실제 공공 데이터를 활용한 실용적인 애플리케이션 개발
- 데이터베이스 처리와 지도 서비스를 결합한 복합적인 기능 구현

## 학습 내용

1. Swift를 이용한 iOS 앱 개발
2. SQLite3 데이터베이스 연동 및 SQL 쿼리 작성
3. MapKit을 활용한 위치 기반 서비스 구현
4. 사용자 위치 권한 요청 및 현재 위치 트래킹 방법
5. Figma를 활용한 UI/UX 디자인 프로세스

