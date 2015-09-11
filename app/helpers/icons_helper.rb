module IconsHelper
  def report_icon
    content_tag(:span, nil, class: 'glyphicon glyphicon-list-alt')
  end

  def edit_icon
    content_tag(:span, nil, class: 'glyphicon glyphicon-wrench')
  end

  def delete_icon
    content_tag(:span, nil, class: 'glyphicon glyphicon-trash')
  end

  def datetime_icon
    content_tag(:span, nil, class: 'glyphicon glyphicon-calendar')
  end

  def address_icon
    content_tag(:span, nil, class: 'glyphicon glyphicon-map-marker')
  end

  def create_icon
    content_tag(:span, nil, class: 'glyphicon glyphicon-plus')
  end

  def link_icon
    content_tag(:span, nil, class: 'glyphicon glyphicon-link')
  end

  def save_icon
    content_tag(:span, nil, class: 'glyphicon glyphicon-ok')
  end

  def mail_icon
    content_tag(:span, nil, class: 'glyphicon glyphicon-envelope')
  end

  def facebook_link_icon
    content_tag(:span, nil, class: 'fa-stack fa-lg') do
      content_tag(:i, nil, class: 'fa fa-circle fa-stack-2x') +
      content_tag(:i, nil, class: 'fa fa-facebook fa-stack-1x fa-inverse')
    end
  end

  def twitter_link_icon
    content_tag(:span, nil, class: 'fa-stack fa-lg') do
      content_tag(:i, nil, class: 'fa fa-circle fa-stack-2x') +
      content_tag(:i, nil, class: 'fa fa-twitter fa-stack-1x fa-inverse')
    end
  end

  def youtube_link_icon
    content_tag(:span, nil, class: 'fa-stack fa-lg') do
      content_tag(:i, nil, class: 'fa fa-circle fa-stack-2x') +
      content_tag(:i, nil, class: 'fa fa-youtube fa-stack-1x fa-inverse')
    end
  end

  def fussballde_link_icon
    content_tag(:span, nil, class: 'fa-stack fa-lg') do
      content_tag(:i, nil, class: 'fa fa-circle fa-stack-2x') +
      content_tag(:i, nil, class: 'fa fa-soccer-ball-o fa-stack-1x fa-inverse')
    end
  end

  def user_icon
    content_tag(:span, nil, class: 'fa fa-user')
  end

  def admin_icon
    content_tag(:span, nil, class: 'fa fa-user-plus')
  end

  def time_icon
    content_tag(:span, nil, class: 'fa fa-clock-o')
  end

  def spinner_icon
    content_tag(:span, nil, class: 'fa fa-spinner fa-pulse')
  end
end
