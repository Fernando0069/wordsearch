# API


## Creación de la API

*** COMANDO DE CREACION ***
oc new-app --name=wordsearch-api https://github.com/fernando0069/wordsearch.git --context-dir=api/ -l app=wordsearch, component=api


## Estructura de archivos
```
word-search-api
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── wordsearch
│   │   │           ├── WordSearchApplication.java        # Main class to run Spring Boot
│   │   │           ├── config                            # Global configuration
│   │   │           ├── controller                        # REST Controllers (Endpoints)
│   │   │           │   ├── UserController.java           # Controller for users
│   │   │           │   ├── GameController.java           # Controller for games
│   │   │           │   ├── LeaderboardController.java    # Controller for leaderboard
│   │   │           ├── model                             # JPA Entities (Representing tables)
│   │   │           │   ├── User.java                     # User model
│   │   │           │   ├── Game.java                     # Game model
│   │   │           │   ├── Achievement.java              # Achievement model
│   │   │           ├── repository                        # JPA Repositories (for data access)
│   │   │           │   ├── UserRepository.java           # Repository for users
│   │   │           │   ├── GameRepository.java           # Repository for games
│   │   │           │   ├── AchievementRepository.java    # Repository for achievements
│   │   │           ├── service                           # Business logic
│   │   │           │   ├── UserService.java              # Business logic for users
│   │   │           │   ├── GameService.java              # Business logic for games
│   │   │           │   ├── LeaderboardService.java       # Business logic for leaderboard
│   │   │           ├── exception                         # Custom exception handling
│   │   │           │   ├── UserNotFoundException.java    # Exception for user not found
│   │   │           │   ├── GameNotFoundException.java    # Exception for game not found
│   │   │           ├── util                              # Utility classes
│   │   │           │   ├── ValidationUtils.java          # Utilities for validation if needed
│   │   ├── resources
│   │   │   ├── application.properties                    # Configuration for database and other parameters
│   │   │   ├── static                                    # Static files (if any, like images)
│   │   │   ├── templates                                 # Templates (if any)
│   ├── test
│   │   ├── java
│   │   │   └── com
│   │   │       └── wordsearch
│   │   │           ├── controller
│   │   │           │   ├── UserControllerTest.java
│   │   │           │   ├── GameControllerTest.java
│   │   │           ├── service
│   │   │           │   ├── UserServiceTest.java
│   │   │           │   ├── GameServiceTest.java
│   │   │           ├── repository
│   │   │           │   ├── UserRepositoryTest.java
│   │   │           │   ├── GameRepositoryTest.java
│   │   │           ├── util
│   │   │           │   ├── ValidationUtilsTest.java
└── pom.xml
```