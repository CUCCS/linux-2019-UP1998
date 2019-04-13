#!/bin/bash

input=""
output=""
q_pct="75"
r_pct="25"
text=""
prefix=""
suffix=""
isCompressQuality="0"
isCompressResolution="0"
isWatermark="0"
isPrefix="0"
isSuffix="0"
isTransJPG="0"

# 帮助信息
function Usage

{
    echo "Usage:"
    echo "  -i  --input <filename>              输入图片"
    echo "  -o  --output <filename>             输出图片"
    echo "  -cq, --compressquality <percent>             对jpeg格式图片进行图片质量压缩"
    echo "  -cr, --compressresolution <percent>          对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率"
    echo "  -w, --watermark <text>              对图片批量添加自定义文本水印"
    echo "  -p, --prefix <prefix>               统一添加文件名前缀，不影响原始文件扩展名"
    echo "  -s, --suffix <suffix>               统一添加文件名后缀，不影响原始文件扩展名"
    echo "  -t, --transfer                      图片格式转换"
    echo "  -h,  --help"
}


# 图片质量压缩
function compressQuality
{
    $(convert "$1" -quality "$2"% "$3")
    echo " CompressQuality "$1" into "$3"."   
}

# 压缩分辨率
function compressResolution
{
    $(convert "$1" -resize "$2"% "$3")
    echo " CompressResolution "$1" into "$3"."  
}

# 添加水印
function addWatermark
{
    $(convert "$1" -draw "gravity east fill black  text 0,12 "$2" " "$3") 
    echo ""$3" contains the text:"$2""
}

# 转换图片格式
function transFormat
{
    $(convert "$1" "$2")
    echo "Transfer "$1" into "$2""
}

# 添加前缀
function addPrefix
{
    for name in `ls *`
    do
        cp "$name" "$1"."$name"
    done
}

# 添加后缀
function addSuffix
{
    for name in `ls *`
        do
        cp "$name" "$name"."$1"
        done
}

# 主函数
while [ $# -gt 0 ]; do
    case "$1" in
        -i|--input)  
		      case "$2" in
		          "") echo "parameter is needed" ; 
				break
				;;
			  *)  input=$2; 
				shift 2 
				;;
		      esac 
		      ;;
                     
        -o|--output)  
                      case "$2" in
		  	  "") echo "parameter is needed" ; 
				break 
				;;
			  *)  output=$2; 
				shift 2 
				;;
		      esac 
		      ;;

        -cq|--quality)         
			q_pct=$2 ; 
			isCompressQuality="1" ; 
			shift 2 
			;;
                      

        -cr|--resolution)      
			r_pct=$2 ; 
			isCompressResolution="1" ; 
			shift 2 
			;;
                              

        -w|--watermark)   
			text=$2 ; 
			isWatermark="1"	 ; 
			shift 2 
			;;		  
			     
   		  	       
	-p|--prefix)	     
			case "$2" in
                        "") echo "parameter is needed" ; 
			break 
			;;
			*)  isPrefix="1" ; 
			prefix=$2 ; 
			shift 2 ;;	  
			esac 
			;;	
		
			
	-s|--suffix)	  
		        case "$2" in
			"") echo "parameter is needed" ; 
			break 
			;;
			*)  isSuffix="1" ; 
			suffix=$2 ; 
			shift 2 
			;;  
		        esac 
			;;
			      
	-t|--transfer) 	     
                        isTransFormat="1"
                        shift 
			;;

        -h|--help)	     
			Usage
                       	exit
                       	;;

	\?)             
		        Usage
                        exit 1 ;;

    esac
   
done


if [ "$isCompressQuality" == "1" ] ; then
	compressQuality $input $q_pct $output
fi

if [ "$isCompressResolution" == "1" ] ; then
        compressResolution $input $r_pct $output
fi

if [ "$isTransJPG" == "1" ] ; then
        transFormat $input $output
fi

if [ "$isWatermark" == "1" ] ; then
        addWatermark $input $text $output
fi

if [ "$isPrefix" == "1"  ] ; then
        addPrefix $prefix
fi

if [ "$isSuffix" == "1" ] ; then
        addSuffix $suffix
fi
