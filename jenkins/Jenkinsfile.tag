pipeline {
    agent any
    environment {
        TAG = "${env.GIT_TAG ?: env.GIT_COMMIT}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Setup') {
            steps {
                bat "echo Tag build: ${TAG}"
            }
        }
        stage('Build') {
            steps {
                bat "docker build -t devops-todo:${TAG} -f Dockerfile ."
            }
        }
        stage('Run (Docker)') {
            steps {
                bat """
                    docker rm -f devops-todo-tag || exit 0
                    docker run -d --name devops-todo-tag -p 3003:3000 devops-todo:${TAG}
                """
            }
        }
        stage('Smoke Test') {
            steps {
                bat "scripts\\smoke.bat http://localhost:3003"
            }
        }
        stage('Archive Artifacts') {
            steps {
                bat "docker image save devops-todo:${TAG} -o devops-todo-${TAG}.tar || exit 0"
                archiveArtifacts artifacts: "devops-todo-${TAG}.tar,**/smoke_result.txt", fingerprint: true
            }
        }
    }
    post {
        always {
            bat "docker rm -f devops-todo-tag || exit 0"
        }
    }
}


// test trigger build

//test build