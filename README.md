# work-wechat-cli
企业微信 Bash 命令行工具

配置文件 work_wechat.cfg.sample
$ mv work_wechat.cfg.sample work_wechat.cfg
# 配置文件内容：
# ##################################################
# 企业微信配置
# Key 大小写无关
# ##################################################
# 
Corp_id=
Secret=
AgentId=
# ToUser 每个 UserID 之间用 | 隔开
# ToUser "@all" 时，发送给企业内所有人
# 官方 API 解释： https://work.weixin.qq.com/api/doc#90000/90135/90236
ToUser=
## 配置文件结束 ##

# 
企业微信官方 API 文档： https://work.weixin.qq.com/api/doc

# 增加了 Token 缓冲
Token 根据 expires_in （根据文档此值不一定为 7200s）,自动调整而不再根据写 token 文件时间
# 增加了发送消息的管道输入
# 

