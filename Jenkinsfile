pipeline {
    agent any
    
    environment {
        IMAGE_NAME = 'yourdockerhubusername/postgresql-rockylinux'
        TAG = 'latest'
    }
    
    stages {
        stage('Build Image') {
            steps {
                script {
                    def dockerfile = """
                        FROM rockylinux/rockylinux:latest
                        
                        RUN dnf update -y && \
                            dnf install -y postgresql-server && \
                            dnf clean all && \
                            rm -rf /var/cache/dnf/*
                            
                        RUN /usr/bin/postgresql-setup --initdb
                        
                        EXPOSE 5432
                        
                        CMD ["postgres", "-D", "/var/lib/pgsql/data"]
                    """
                    
                    sh "echo '${dockerfile}' > Dockerfile"
                    
                    sh "docker build -t ${IMAGE_NAME}:${TAG} ."
                }
            }
        }
        
        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-creds', variable: 'DOCKERHUB_CREDENTIALS')]) {
                    sh "docker login -u yourdockerhubusername -p ${DOCKERHUB_CREDENTIALS}"
                    
                    sh "docker push ${IMAGE_NAME}:${TAG}"
                }
            }
        }
    }
}
