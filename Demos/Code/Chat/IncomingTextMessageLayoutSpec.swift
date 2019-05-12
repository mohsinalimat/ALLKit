import Foundation
import UIKit
import ALLKit
import yoga

final class IncomingTextMessageLayoutSpec: ModelLayoutSpec<ChatMessage> {
    override func makeNodeFrom(model: ChatMessage, sizeConstraints: SizeConstraints) -> LayoutNode {
        let attributedText = model.text.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(UIColor.black)
            .make()
            .drawing()

        let attributedDateText = DateFormatter.localizedString(from: model.date, dateStyle: .none, timeStyle: DateFormatter.Style.short).attributed()
            .font(.italicSystemFont(ofSize: 10))
            .foregroundColor(UIColor.black.withAlphaComponent(0.6))
            .make()

        let tailNode = LayoutNode(config: { node in
            node.position = .absolute
            node.width = 20
            node.height = 18
            node.bottom = 0
            node.left = -6
        }) { (imageView: UIImageView, _) in
            imageView.superview?.sendSubviewToBack(imageView)
            imageView.image = UIImage(named: "tail")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = ChatColors.incoming
            imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }

        let textNode = LayoutNode(sizeProvider: attributedText, config: { node in
            node.flexShrink = 1
            node.marginRight = 8
        }) { (label: AsyncLabel, _) in
            label.stringDrawing = attributedText
        }

        let dateNode = LayoutNode(sizeProvider: attributedDateText, config: nil) { (label: UILabel, _) in
            label.attributedText = attributedDateText
        }

        let infoNode = LayoutNode(children: [dateNode], config: { node in
            node.marginBottom = 2
            node.flexDirection = .row
            node.alignItems = .center
            node.alignSelf = .flexEnd
        })

        let backgroundNode = LayoutNode(children: [textNode, tailNode, infoNode], config: { node in
            node.flexDirection = .row
            node.alignItems = .center
            node.padding(top: 8, left: 12, bottom: 8, right: 12)
            node.margin(top: nil, left: 16, bottom: 8, right: 30%)
            node.minHeight = 36
        }) { (view: UIView, _) in
            view.backgroundColor = ChatColors.incoming
            view.layer.cornerRadius = 18
        }

        return LayoutNode(children: [backgroundNode], config: { node in
            node.alignItems = .center
            node.flexDirection = .row
        })
    }
}
