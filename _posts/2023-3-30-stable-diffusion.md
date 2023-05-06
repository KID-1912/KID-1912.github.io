## 关键词

**发型**
long hair 长发
medium hair 中发
very long hair 超长发 
short hair 短发
high ponytail 高尾
low twintails 双马尾
ponytail 马尾
short_ponytail 短尾
twin_braids 双辫子
bangs 流海
blunt bangs 齐刘海
double bun 包子头
messy_hair 凌乱

**发色**
purple hair 紫发
blonde hair 金
white hair 白
two-tone hair 双色
grey hair 灰
silver_hair 银
brown hair 棕
streaked hair 挑染

**表情**
light smile 眼睛
brown hair 诱惑笑
grin 咧嘴笑
laughing 笑
excited 兴奋
embarrassed 害羞
angry 生气
annoyed 苦恼
frown 皱眉
delicate face 娇嫩脸
longeyelashes 长睫毛

**眼睛**
aqua eyes 水汪汪大眼
looking at viewer 看著你
stare 凝视
visible through hair 透过流海看
looking to the side 看旁边
constricted pupils 收缩的瞳孔
half-closed eyes 半闭眼睛
wink 眨眼
mole under eye 眼下痣
eyes closed 闭眼

**装饰**
animal_ears 动物耳朵
fox ears狐狸耳朵
bunny_ears兔子耳朵
cat ears猫耳
dog_ears狗耳
tiara皇冠
hairclip发夹
hair ribbon发带
hair_flower发花
hair_ornament发饰
bowtie蝴蝶结
hair bow蝴蝶发饰
maid headdress女仆发饰

**构图**
full body 全身
upclose 半身

类型
realistic, photo-realistic:1.37

质量
(8k, RAW photo, best quality, masterpiece:1.2)
光与渲染
 professional lighting, photon mapping, radiosity, physically-based rendering,

1girl,New Style Cheongsam,hair ribbon,bowtie,blunt bangs,Hairpin,Beautiful face,upon_body, long hair,{looking at viewer},((Chinese Ancient Style))
,(8k, best quality, masterpiece:1.2,ultra-detailed),(realistic, photo-realistic:1.3),

反提示词

EasyNegative, 
paintings, 
sketches, 
(worst quality:2), (low quality:2), (normal quality:2), lowres, normal quality, ((monochrome)), ((grayscale)), skin spots, acnes, skin blemishes, age spot, (outdoor:1.6), manboobs, backlight,(ugly:1.331), (duplicate:1.331), (morbid:1.21), (mutilated:1.21), (tranny:1.331), mutated hands, (poorly drawn hands:1.331), blurry, (bad anatomy:1.21), (bad proportions:1.331), extra limbs, (disfigured:1.331), (more than 2 nipples:1.331), (missing arms:1.331), (extra legs:1.331), (fused fingers:1.61051), (too many fingers:1.61051), (unclear eyes:1.331), bad hands, missing fingers, extra digit, (futa:1.1), bad body, NG_DeepNegative_V1_75T,pubic hair, glans,

1. 接入谷歌云盘

```sh
from google.colab import drive # type: ignore

try:
   drive_path = "/content/drive"
   drive.mount(drive_path,force_remount=False)
except:
   print("...error mounting drive or with drive path variables")
```

2. 运行
   请确保GPU运行时

```shell
%cd /content/drive/MyDrive/stable-diffusion-webui
!git checkout 91c8d0d
!COMMANDLINE_ARGS="--share --disable-safe-unpickle --no-half-vae --xformers --reinstall-xformers --enable-insecure-extension-access" REQS_FILE="requirements.txt" python launch.py
```

**源部署命令**

```
%cd /content/drive/MyDrive
!pip install --upgrade fastapi==0.90.0
!git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
!git clone https://github.com/yfszzx/stable-diffusion-webui-images-browser /content/drive/MyDrive/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
!curl -Lo chilloutmixni.safetensors https://huggingface.co/nolanaatama/chomni/resolve/main/chomni.safetensors
!curl -Lo koreanDollLikeness_v10.safetensors https://huggingface.co/duthanhduoc/chilloutmix-set/resolve/main/koreanDollLikeness_v10.safetensors
!curl -Lo japaneseDollLikeness_v10.safetensors https://huggingface.co/aimainia/japaneseDollLikeness_v10/blob/main/japaneseDollLikeness_v10.safetensors
!mkdir /content/drive/MyDrive/stable-diffusion-webui/models/Lora
!mv "/content/drive/MyDrive/koreanDollLikeness_v10.safetensors" "/content/drive/MyDrive/stable-diffusion-webui/models/Lora"
!mv "/content/drive/MyDrive/japaneseDollLikeness_v10.safetensors" "/content/drive/MyDrive/stable-diffusion-webui/models/Lora"
!mv "/content/drive/MyDrive/chilloutmixni.safetensors" "/content/drive/MyDrive/stable-diffusion-webui/models/Stable-diffusion"
!mv "/content/drive/MyDrive/ulzzang-6500.pt" "/content/drive/MyDrive/stable-diffusion-webui/embeddings"
%cd /content/drive/MyDrive/stable-diffusion-webui
!git checkout 91c8d0d
!COMMANDLINE_ARGS="--share --disable-safe-unpickle --no-half-vae --xformers --reinstall-xformers --enable-insecure-extension-access" REQS_FILE="requirements.txt" python launch.py
```

**launch.py 修正**

```
if current_hash == commithash:
   return

p = subprocess.Popen([git, "-C", dir, "status", "--porcelain"], stdout=subprocess.PIPE)
out, err = p.communicate()
if out.strip() != b'':
    run(f'"{git}" -C "{dir}" add .', f"Adding changes for {name}...", f"Couldn't add changes for {name}")
    run(f'"{git}" -C "{dir}" commit -m "Committing changes before checkout"', f"Committing changes for {name}...", f"Couldn't commit changes for {name}")

run(f'"{git}" -C "{dir}" fetch', f"Fetching updates for {name}...", f"Couldn't fetch {name}")
run(f'"{git}" -C "{dir}" checkout {commithash}', f"Checking out commit for {name} with hash: {commithash}...", f"Couldncheckout commit {commithash} for {name}")

return
```

**git配置**

```
!git config --global user.email "you@example.com"
!git config --global user.name "Your Name"
```

**模型下载**

/content/gdrive/MyDrive/model; wget url --content-disposition
