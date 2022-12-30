//
//  DiseaseCellView.swift
//  EDOCTOR
//
//  Created by Muhammad Salman on 1/7/22.
//

import SwiftUI

struct DiseaseCellView: View {

    var disease: DiseasesData?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(disease?.name ?? "Disease name")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)
                Text(disease?.datumDescription ?? "Disease description goes here...")
                    .font(.caption)
                    .foregroundColor(.black)
                    .opacity(0.7)
                    .lineLimit(2)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.leading)

                HStack {
                    Text("Created:")
                        .font(.caption)
                    Text(disease?.createdAt?.prefix(10) ?? "00 January, 0000")
                        .font(.caption2)

                    Spacer()

                    Text("Updated:")
                        .font(.caption)
                    Text(disease?.updatedAt?.prefix(10) ?? "00 March, 0000")
                        .font(.caption2)
                }
                .opacity(0.5)
            }
            Spacer()
            Image(systemName: "chevron.forward")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.leading, 5)
        }
        .padding()
        .background(appColor2)
        .cornerRadius(15)
        .shadow(color: .gray, radius: 1)
    }
}


struct DiseaseCellView_Previews: PreviewProvider {
    static var previews: some View {
        DiseaseCellView()
    }
}
