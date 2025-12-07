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
        sh 'echo "Tag build: ${TAG}"'
      }
    }
    stage('Build') {
      steps {
        sh 'docker build -t devops-todo:${TAG} -f Dockerfile .'
      }
    }
    stage('Run (Docker)') {
      steps {
        sh '''
          docker rm -f devops-todo-tag || true
          docker run -d --name devops-todo-tag -p 3003:3000 devops-todo:${TAG}
        '''
      }
    }
    stage('Smoke Test') {
      steps {
        sh './scripts/smoke.sh http://localhost:3003'
      }
    }
    stage('Archive Artifacts') {
      steps {
        sh '''
          docker image save devops-todo:${TAG} -o devops-todo-${TAG}.tar || true
        '''
        archiveArtifacts artifacts: "devops-todo-${TAG}.tar,**/smoke_result.txt", fingerprint: true
      }
    }
  }
  post {
    always {
      sh 'docker rm -f devops-todo-tag || true'
    }
  }
}
