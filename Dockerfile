FROM myregistry.com/root/demo/java
ADD build/libs/spring-music_master-1.0.jar ./app.jar
CMD ["java","-jar","app.jar"]
