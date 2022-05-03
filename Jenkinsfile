ports = [ 81, 82, 83, 84, 85 ]
pipeline {
    agent {
        node {
            label 'slave2'
        }
    }
    parameters {
    	string(name: 'serverIP', defaultValue: 'None', description: 'Enter target Host IP ')
	string(name: 'targetHost', defaultValue: 'None', description: 'Enter target host for deployment ')
	string(name: 'dockerUser', defaultValue: 'None', description: 'Enter Docker user name ')
    }
    environment {
		DOCKERHUB_CREDENTIALS=credentials('dockerhub')
    }
    stages {
        stage('SCM checkout'){
        	steps {
			git "https://github.com/vistasunil/jenkins-cicd-webinar.git"
            	}
	}
	stage('Remove dockers'){
		steps {
			sh "if [ `sudo docker ps -a -q|wc -l` -gt 0 ]; then sudo docker rm -f \$(sudo docker ps -a -q);fi"
		}
	}
	stage('Build'){
		steps {
			sh "sudo docker build /home/ubuntu/jenkins/workspace/${JOB_NAME} -t ${dockerUser}/devopsdemo"
		}
	}
	stage('Docker Push'){
		steps {
			sh "echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login --username ${dockerUser} --password-stdin"
			sh "sudo docker push ${dockerUser}/devopsdemo:latest"
		}
	}
	stage('Configure servers with Docker and deploy website') {
		steps {
			sh 'ansible-playbook docker.yaml -e "hostname=${targetHost}"'
		}
	}
	stage('Test the website') {
		steps {
			test_web(ports,serverIP)
		}
	}
    }
}

@NonCPS // has to be NonCPS or the build breaks on the call to .each
def test_web(list,serverIP) {
    list.each { item ->
	    curl "http://${serverIP}:${item}"
    }
}
