FROM ubuntu:18.10
RUN apt update && apt install hashcat -y
ADD /rockyou.txt.gz /tmp/
ADD /hash/zhopa.hash /tmp/
RUN gunzip /tmp/rockyou.txt.gz
RUN ln -s /usr/lib/llvm-6.0/lib/clang/6.0.1 /usr/lib/llvm-6.0/lib/clang/6.0.0
