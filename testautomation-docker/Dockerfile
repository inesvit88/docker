FROM ubuntu:18.10 

RUN apt update -y \
 && apt install -y python3 python3-pip netcat vim

RUN pip3 install selenium
RUN pip3 install pytest-html

RUN mkdir -p /opt/pytest/testrail
ADD tests/google_smoke_test.py /opt/pytest/google_smoke_test.py
