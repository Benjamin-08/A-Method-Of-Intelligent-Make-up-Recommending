%% ��ջ�������
clc
clear

%% ѵ������Ԥ������
data=xlsread('nose_data.xlsx');

%��1��349��������򣬲������������ֹ�����
k=rand(1,97);%��������(0, 1)֮����ȷֲ����������ɵ����顣
[m,n]=sort(k);%m������õ�������n �� ����m�ж�k������,�����ͽ������������˳������������ˣ��������ȡ������


input=data(:,1:4);%��������
group=data(:,5);%��ǩ

%�����ȡ280������Ϊѵ����������ѵ�����Ͳ��Լ����ѡ��69������ΪԤ������
input_train=input(n(1:69),:)';%ѵ��������Ҫת��
output_train=group(n(1:69),:)';%ѵ����ǩ��Ҫת��
input_test=input(n(70:97),:)';%����������Ҫת��
output_test=group(n(70:97),:)';%���Ա�ǩ��Ҫת��

%�������ݹ�һ��
[inputn,inputps]=mapminmax(input_train);

%% BP����ѵ��
% %��ʼ������ṹ
net=newff(inputn,output_train,10);

net.trainParam.epochs=1000;
net.trainParam.lr=0.1;
net.trainParam.goal=0.0000004;

%% ����ѵ��
net=train(net,inputn,output_train);

%% BP����Ԥ��
%Ԥ�����ݹ�һ��
inputn_test=mapminmax('apply',input_test,inputps);

%����Ԥ�����
BPoutput=sim(net,inputn_test);%Ԥ���ǩ

%% �������
%������������ҳ�������������
BPoutput(find(BPoutput<1.5))=1;
BPoutput(find(BPoutput>=1.5&BPoutput<2.5))=2;
BPoutput(find(BPoutput>=2.5&BPoutput<3.5))=3;
BPoutput(find(BPoutput>=3.5))=4;
%% �������
%����Ԥ�������ʵ������ķ���ͼ
figure(1)
plot(BPoutput,'og')
hold on
plot(output_test,'r*');
legend('Ԥ�����','������')
title('BP����Ԥ�������ʵ�����ȶ�','fontsize',12)
ylabel('����ǩ','fontsize',12)
xlabel('������Ŀ','fontsize',12)
ylim([-0.5 4.5])


%Ԥ����ȷ��
rightnumber=0;
for i=1:size(output_test,2)
    if BPoutput(i)==output_test(i)
        rightnumber=rightnumber+1;
    end
end
rightratio=rightnumber/size(output_test,2)*100;

sprintf('����׼ȷ��=%0.2f',rightratio)

w1=net.iw{1,1};
theta1=net.b{1};
w2=net.lw{2,1};
theta2=net.b{2};
