FROM maven:3.8-openjdk-11 as builder

WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# 第二阶段：运行应用
FROM openjdk:11-jre-slim

WORKDIR /app

# 从构建阶段复制编译好的jar文件
COPY --from=builder /app/target/*.jar app.jar

# 设置环境变量
ENV SPRING_PROFILES_ACTIVE=mysql
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# 暴露应用端口
EXPOSE 8080

# 启动命令
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
