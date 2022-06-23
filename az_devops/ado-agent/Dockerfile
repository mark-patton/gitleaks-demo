FROM ubuntu:20.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu66 \
        libunwind8 \
        netcat \
        libssl1.0 \
&& apt-get update \
&& apt-get install -y --no-install-recommends \
        default-jre \
        openjdk-11-jre-headless \
        openjdk-8-jre-headless \
&& wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
&& dpkg -i packages-microsoft-prod.deb \
&& apt-get install -y --no-install-recommends software-properties-common \
&& add-apt-repository universe \
&& apt-get install -y --no-install-recommends apt-transport-https \
&& apt-get update \
&& apt-get install -y --no-install-recommends dotnet-sdk-3.1 \
&& apt-get update \
&& apt-get install -y --no-install-recommends aspnetcore-runtime-3.1 \
&& apt install -y --no-install-recommends gnupg ca-certificates \
&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
&& echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
&& apt update \
&& apt install -y --no-install-recommends mono-devel \
&& apt-get install -y --no-install-recommends unzip \
&& wget https://releases.hashicorp.com/terraform/0.14.2/terraform_0.14.2_linux_amd64.zip \
&& unzip terraform_0.14.2_linux_amd64.zip  \
&& mv terraform /usr/local/bin \
&& terraform --version \
&& curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \ 
&& apt-get update && apt-get install -y --no-install-recommends packer \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]