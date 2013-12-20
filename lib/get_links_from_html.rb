#encoding: utf-8
require 'rest_client'

Link = Struct.new(:url, :text)  # URL�ȥƥ����Ȥ���¸���륯�饹

def getlinks(data)
  list = Array.new          # ������̤���¸���뤿��Υꥹ��(����)
  current = nil             # ���߽�����Υ��

  #count = 0 
  HTML::scan(data){|item|
    #puts "item"
    #puts item
    #count += 1
    #puts item.size
    case item
    when HTML::StartTag
      case item.name
      when "A"
        # A���Ǥγ��ϥ����������ä��顤������ Link ���֥������Ȥ���������
        current = Link.new(item.attribute['href'], "")
      when "IMG"
        # IMG���Ǥ����Ƥ�����ʤ��Τǡ����Τޤޥꥹ�Ȥ��ɲä���
        src = item.attribute['src']
        alt = item.attribute['alt']
        list.push(Link.new(src, alt))
        current.text << alt if current     # �ƥ����Ȥ��ɲä���
      end
    when HTML::EndTag
      if item.name == "A" and current
        # A���Ǥν�λ�����������ä��顤current��ꥹ�Ȥ��ɲä���
        list.push(current) if current.url
        current = nil
      end
    when HTML::TextData
      current.text << item.value if current # �ƥ����Ȥ��ɲä���
    end
  }
  #puts "count:  "
  #puts count
  return list
end

#  main
