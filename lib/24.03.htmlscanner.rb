module  HTML
  HTMLRegexp = /(<!--.*?--\s*>)|
                (<(?:[^"'>]*|"[^"]*"|'[^']*')+>)|
                ([^<]*)/xm
  MarkUpDeclRegexp = /^<!/
  EndTagRegexp = /^<\/(\w+)>/
  StartTagRegexp = /^<(\w+)(.*)>/m
  AttrRegexp = /(\w+)(?:=(?:"([^"]*)"|'([^']*)'|([^'"\s]*)))?/

  # class Item: ���Ϸ�̤���¸���뤿��Υ��饹
  Item = Struct.new(:name, :attribute, :value, :source)
  class Comment    < Item; end
  class MarkUpDecl < Item; end
  class StartTag   < Item; end
  class EndTag     < Item; end
  class TextData   < Item; end

  def scan(data)
    data.scan(HTMLRegexp).each{|match|
      comment, tag, tdata = match[0..2]
      if comment
        /^<!--(.*)--\s*>/om =~ comment # �����Ȥ����Ƥ���Ф�
        item = Comment.new(nil, nil, $1, comment)
      elsif tag
        case tag
        when MarkUpDeclRegexp
          item = MarkUpDecl.new(nil, nil, tag, tag)
        when EndTagRegexp
          item = EndTag.new($1.upcase, nil, nil, tag)
        when StartTagRegexp
          # �������顤����̾��°������Ф�
          # ����̾����ʸ�����Ѵ�����
          elem_name, attrs = $1.upcase, $2

          # °����1�Ĥ��ļ��Ф��ƥϥå���˳�Ǽ����
          # °��̾�Ͼ�ʸ�����Ѵ������ͤ� unescape ����
          attr = Hash.new
          attrs.scan(AttrRegexp){
            attr_name = $1
            value = $2 || $3 || $4 # $2����$4�Τ������ޥå��������
            attr[attr_name.downcase] = unescape(value)
          }
          item = StartTag.new(elem_name, attr, nil, tag)
        end
      elsif tdata
        item = TextData.new(nil, nil, unescape(tdata), tdata)
      end
      yield(item)
    }
  end

  module_function :scan

  def unescape(str)
    return nil unless str
    ret = str.dup
    ret.gsub!(/&#(\d+);|&(\w+);/){|m|
      num, name = $1, $2
      if num               then num.to_i.chr
      elsif name == "quot" then '"'
      elsif name == "amp"  then '&'
      elsif name == "lt"   then '<'
      elsif name == "gt"   then '>'
      else m
      end
    }
    ret
  end
  module_function :unescape
end # module HTML
