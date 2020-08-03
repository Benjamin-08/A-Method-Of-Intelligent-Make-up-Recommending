clc;
clear all;

train_num = 85;
%��ȡexcel�ļ�
face_index_edan = xlsread('face_index_edan.xls');
face_index_edan = [face_index_edan(:,1),face_index_edan(:,3)];
face_index_guazi = xlsread('face_index_guazi.xls');
face_index_guazi = [face_index_guazi(:,1),face_index_guazi(:,3)];
%����ѵ������
face_train_data = [face_index_edan(1:train_num,:);face_index_guazi(1:train_num,:)];
face_train_judge1 = ones(1,train_num)';
face_train_judge2 = zeros(1,train_num)';
face_train_judge = [face_train_judge1;face_train_judge2];
%�����������
face_test_data = [face_index_edan(train_num+1:length(face_index_edan),:);face_index_guazi(train_num+1:length(face_index_guazi),:)];
%���������߼��ع�
[testNum, attrNum] = size(face_test_data);
face_testdata2 = [ones(testNum,1), face_test_data];
B = glmfit(face_train_data, [face_train_judge,ones(size(face_train_judge))],'binomial', 'link', 'logit');
p = 1.0 ./ (1 + exp(- face_testdata2 * B));
%����ɢ��ͼ
face_shape_index_edan = face_index_edan(:,1);
face_jaw_r_index_edan = face_index_edan(:,2);  
plot(face_shape_index_edan,face_jaw_r_index_edan,'rx')
hold on

face_shape_index_guazi = face_index_guazi(:,1);
face_jaw_r_index_guazi = face_index_guazi(:,2);
plot(face_shape_index_guazi,face_jaw_r_index_guazi,'bx')

xlabel('face shape index')
ylabel('face jaw r index')
grid on
title('����ָ��ɢ��ͼ')
legend('�쵰��','������')
%�����ع�����
hold on
x = 0.7:0.001:0.88;   
y = (B(2,1)/-B(3,1)).*x+B(1,1)/-B(3,1);
plot(x,y)

%����������
true_num = 0;
for i = 1:length(face_index_edan)-length(face_train_judge1)
    if(p(i)>=0.5)
        true_num = true_num + 1;
    end
end

for i = 1:length(face_index_guazi)-length(face_train_judge2)
    if(p(i+length(face_index_edan)-length(face_train_judge1))<0.5)
        true_num = true_num + 1;
    end
end

true_rate = true_num/length(p);
false_rate = 1 - true_rate;
T = ['��ȷ�ʣ�',num2str(true_rate)];
F = ['�����ʣ�',num2str(false_rate)];
disp('ʹ��Logistic regression��')
disp(T)
disp(F)


