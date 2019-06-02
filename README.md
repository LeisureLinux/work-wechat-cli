# work-wechat-cli
企业微信 Bash 命令行工具

配置文件 work_wechat.cfg.sample
* mv work_wechat.cfg.sample work_wechat.cfg
配置文件内容：
 
#企业微信配置

#Key 大小写无关

Corp_id=

Secret=

AgentId=

ToUser=


 ToUser 每个 UserID 之间用 | 隔开
 ToUser "@all" 时，发送给企业内所有人
* 官方 API 解释： https://work.weixin.qq.com/api/doc#90000/90135/90236

 
 
企业微信官方 API 文档： https://work.weixin.qq.com/api/doc

* 增加了 Token 缓冲
* 增加了发送消息的管道输入
 

