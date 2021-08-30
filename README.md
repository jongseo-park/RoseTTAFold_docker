# ***RoseTTAFold_docker***

<br/>

*[RoseTTAFold](https://github.com/RosettaCommons/RoseTTAFold)*

<br/>

This repository has a Dockerfile for build the RoseTTAFold docker image.

To use this repository ...

1. You need a license of PyRosetta (username / passwd) -- 
*[PyRosetta](https://www.pyrosetta.org)*
2. This docker image may not work in your system due to the differences of system environment. Please refer to my system environment.

<br/>

    Ubuntu 20.04
    i9-10900x
    128 GB RAM
    RTX 3080 * 2 ea
    CUDA version 11.2
    NVIDIA driver version 460.27.04


<br/>

- - -

*For Korean*

<br/>

이 저장소에서는 RoseTTAFold 의 도커 이미지를 빌드할 수 있는 Dockerfile 을 제공합니다.

사용을 위해서 ...

1. PyRosetta 의 라이센스 (username / passwd) 가 필요합니다 -- *[PyRosetta](https://www.pyrosetta.org)*

2. 시스템 환경에 따라 도커 이미지가 작동하지 않을 수 있습니다. 제 시스템 환경을 참고하세요.

<br/>

    Ubuntu 20.04
    i9-10900x
    128 GB RAM
    RTX 3080 * 2 ea
    CUDA version 11.2
    NVIDIA driver version 460.27.04

<br/>

상세한 한글 설명은 맨 아래에 작성되어 있습니다.



<br/>

- - -

## ***How to use***

### **1. Obtain a license of PyRosetta**

Please refer to the PyRosetta website.

<br/>

### **2. Get a Dockerfile and build the image**

    git clone https://github.com/jongseo-park/RoseTTAFold_docker


After get a Dockerfile, you have to enter the license information in line 45 of Dockerfile.

    line45: RUN wget --user=name --password=passwd  ...

Just change the `name` and `passwd` to the information you obtained from PyRosetta distribution server.

<br/>

Then, build the RoseTTAFold docker image as follows.

    docker build -t imagename:tag ./

    eg)
    docker build -t rosettafold:v01 ./

`./` is the path to the directory containing the Dockerfile.

Note that the size of the image is about 30 GB.

<br/>

### **3. Working directory setup**

Before use the docker container, you have to download several database files.

You can find the download link in the *[RoseTTAFold](https://github.com/RosettaCommons/RoseTTAFold)* (Github page).

After you download all of the databases, please set the directory as follows. 

Be sure that the name of the database directory have to be the `DAT`.


    Working_dir/

        DAT/
            bfd/
                bfd_metaclus_clu.....
                ...


            pdb100_2021Mar03/
                pdb100_2021Mar03_a3m.ffdata
                ...

            UniRef30_2020_06/
                UniRef30_2020_06_a3m.ffdata
                ...

            weights/
                RoseTTAFold_pyrosetta.py
                ...

        result/

        input.fa
        
`input.fa` is a file containing your protein sequence in fasta format.

Note that the total volume of those databases are about 3 TB.

<br/>

### **4. Run the docker container from the image with mounting of the working directory**

    docker run 
        -it 
        --gpus all
        -v "/path/to/working/directory/:/home/run/" 
        imagename:tag

<br/>

If you want to select the specific GPU, then replace the argument, `--gpus all`, like `--gpus '"device=0"'`. Then, your docker container only use the GPU of device number 0.

In addition, you have to keep the destination volume as `/home/run/` because the symbolic link of `/home/run/DAT/...` is connected with the database in the RoseTTAFold directory as follows.

    /home/run/DAT/bfd >> /opt/RoseTTAFold/bfd
    /home/run/DAT/pdb100_2021Mar03 >> /opt/RoseTTAFold/pdb100_2021Mar03
    /home/run/DAT/UniRef30_2020_06 >> /opt/RoseTTAFold/UniRef30_2020_06
    /home/run/DAT/weights >> /opt/RoseTTAFold/weights


<br/>

### **5. Run the RoseTTAFold**

In the docker container, just run the RoseTTAFold as follows.

    $ run_pyrosetta_ver.sh /path/to/fastafile /path/to/result

    eg)
    $ run_pyrosetta_ver.sh ./input.fa ./result


<br/>
<br/>


*Thanks.*

- - -
- - -
<br/>

*For Korean*

## ***사용법***

### **1. PyRosetta 라이센스 얻기**

PyRosetta 홈페이지를 참조하세요.

<br/>

### **2. Dockerfile 을 이용하여 이미지 빌드하기**

    git clone https://github.com/jongseo-park/RoseTTAFold_docker

<br/>

Dockerfile 을 다운로드 했으면, Dockerfile 의 45번째 줄에 PyRosetta 라이센스 정보를 입력해야 합니다.

    line45: RUN wget --user=name --password=passwd  ...

여기서 `name` 과 `passwd` 를 본인이 얻은 PyRosetta 라이센스 정보대로 변경하세요.


<br/>

그 다음, 아래와 같이 RoseTTAFold 도커 이미지를 빌드합니다.


    docker build -t imagename:tag ./

    eg)
    docker build -t rosettafold:v01 ./

`./` 는 Dockerfile 이 위치한 경로를 의미합니다.

참고로 이미지의 크기는 30 GB 정도 입니다.

<br/>

### **3. 작업 디렉토리 설정**

도커 컨테이너를 사용하기 전, 각종 데이터베이스 파일을 다운로드 해야 합니다.

해당 다운로드 링크는 *[RoseTTAFold](https://github.com/RosettaCommons/RoseTTAFold)* (Github page) 에서 확인할 수 있습니다.

모든 데이터베이스를 다운로드 했으면 아래와 같이 경로를 설정해주세요.



    Working_dir/

        DAT/
            bfd/
                bfd_metaclus_clu.....
                ...


            pdb100_2021Mar03/
                pdb100_2021Mar03_a3m.ffdata
                ...

            UniRef30_2020_06/
                UniRef30_2020_06_a3m.ffdata
                ...

            weights/
                RoseTTAFold_pyrosetta.py
                ...

        result/

        input.fa
        
`input.fa` 는 분석을 원하는 단백질 시퀀스를 fasta 형식으로 저장해둔 파일 입니다.

데이터베이스의 용량은 3 TB 정도이니 참고하세요.

<br/>

### **4. 작업 디렉토리를 마운트하여 도커 컨테이너 실행하기**

    docker run 
        -it 
        --gpus all
        -v "/path/to/working/directory/:/home/run/" 
        imagename:tag

<br/>

특정 GPU 를 선택해서 사용하고 싶으면 `--gpus all` 을 `--gpus '"device=0"'` 처럼 변경해주세요. 이렇게 하면 도커 컨테이너는 device number 0 번인 GPU 만을 사용하게 됩니다.

추가로, 도커 이미지 내에서 볼륨 마운트 되는 경로인 `/home/run/` 은 반드시 유지해야 합니다. 왜냐하면, 도커 이미지 내의 RoseTTAFold 경로에 있는 데이터베이스 디렉토리와 `/home/run/DAT/...` 경로가 심볼릭 링크로 연결되어있기 때문입니다. <br/>
(아래 블럭 참조)


    /home/run/DAT/bfd >> /opt/RoseTTAFold/bfd
    /home/run/DAT/pdb100_2021Mar03 >> /opt/RoseTTAFold/pdb100_2021Mar03
    /home/run/DAT/UniRef30_2020_06 >> /opt/RoseTTAFold/UniRef30_2020_06
    /home/run/DAT/weights >> /opt/RoseTTAFold/weights

다른 경로를 원하면 직접 심볼릭링크를 설정해서 사용하시면 됩니다.

<br/>

### **5. RoseTTAFold 실행**

도커 컨테이너에서 아래 커맨드를 통해 RoseTTAFold 를 실행하세요.


    $ run_pyrosetta_ver.sh /path/to/fastafile /path/to/result

    eg)
    $ run_pyrosetta_ver.sh ./input.fa ./result


<br/>
<br/>


*감사합니다*