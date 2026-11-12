FROM tomcat:9.0-jdk11

# Tải MySQL JDBC Connector vào thư viện dùng chung của Tomcat
ADD https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.2.0/mysql-connector-j-8.2.0.jar /usr/local/tomcat/lib/

# Xóa ứng dụng mặc định trong ROOT
RUN rm -rf /usr/local/tomcat/webapps/ROOT/*

# Sao chép giao diện và cấu hình từ WebContent vào thư mục ROOT
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/

# Tạo thư mục chứa các class Java
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    && mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/lib

# Đặt MySQL connector vào cả WEB-INF/lib của ứng dụng
RUN cp /usr/local/tomcat/lib/mysql-connector-j-8.2.0.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# Sao chép toàn bộ mã nguồn Java
COPY src/ /tmp/src/

# Biên dịch toàn bộ các file Java (Model & DAO)
RUN javac -encoding UTF-8 \
    -cp "/usr/local/tomcat/lib/*:/usr/local/tomcat/webapps/ROOT/WEB-INF/lib/*" \
    -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    /tmp/src/model/*.java /tmp/src/dao/*.java \
    && rm -rf /tmp/src

EXPOSE 8080

CMD ["catalina.sh", "run"]
