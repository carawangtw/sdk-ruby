require 'spec_helper'

RSpec.describe Smartpay::Requests::CheckoutSession do
  subject { Smartpay::Requests::CheckoutSession.new(request) }

  describe '#check_requirement!' do
    context 'when the raw_payload is not contained successURL' do
      let(:request) { {} }

      it { expect { subject.send(:check_requirement!) }.to raise_error(Smartpay::Errors::InvalidRequestPayloadError) }
    end

    context 'when the raw_payload is not contained customerInfo' do
      let(:request) do
        {
          successURL: 'https://docs.smartpay.co/example-pages/checkout-successful',
          cancelURL: 'https://docs.smartpay.co/example-pages/checkout-canceled'
        }
      end

      it { expect { subject.send(:check_requirement!) }.not_to raise_error(Smartpay::Errors::InvalidRequestPayloadError) }
    end
  end

  describe '#normalize_payload' do
    let(:request) do
      {
        items: [{
          name: "オリジナルス STAN SMITH",
          amount: 250,
          currency: "JPY",
          quantity: 1
        }],
        customer: {
          accountAge: 20,
          email: "merchant-support@smartpay.co",
          firstName: "田中",
          lastName: "太郎",
          firstNameKana: "たなか",
          lastNameKana: "たろう",
          address: {
            line1: "3-6-7",
            line2: "青山パラシオタワー 11階",
            subLocality: "",
            locality: "港区北青山",
            administrativeArea: "東京都",
            postalCode: "107-0061",
            country: "JP"
          },
          dateOfBirth: "1985-06-30",
          gender: "male"
        },
        shipping: {
          line1: "line1",
          locality: "locality",
          postalCode: "123",
          country: "JP",
          feeAmount: 100
        },
        reference: "order_ref_1234567",
        successURL: "https://docs.smartpay.co/example-pages/checkout-successful",
        cancelURL: "https://docs.smartpay.co/example-pages/checkout-canceled",
        test: true
      }
    end

    it do
      expect(subject.send(:normalize_payload)).to eq({
        orderData: {
          amount: 350,
          captureMethod: nil,
          confirmationMethod: nil,
          coupons: nil,
          currency: "JPY",
          lineItemData: [{
            description: nil,
            metadata: nil,
            price: nil,
            priceData: {
              amount: 250,
              currency: "JPY",
              metadata: nil,
              productData: {
                brand: nil,
                categories: nil,
                description: nil,
                gtin: nil,
                images: nil,
                metadata: nil,
                name: "オリジナルス STAN SMITH",
                reference: nil,
                url: nil
              }
            },
            quantity: 1
          }],
          shippingInfo: {
            address: {
              administrativeArea: nil,
              country: "JP",
              line1: "line1",
              line2: nil,
              line3: nil,
              line4: nil,
              line5: nil,
              locality: "locality",
              postalCode: "123",
              subLocality: nil
            },
            addressType: nil,
            feeAmount: 100,
            feeCurrency: "JPY"
          }
        },
        reference: "order_ref_1234567",
        successUrl: "https://docs.smartpay.co/example-pages/checkout-successful",
        cancelUrl: "https://docs.smartpay.co/example-pages/checkout-canceled",
        customerInfo: {
          accountAge: 20,
          address: {
            administrativeArea: "東京都",
            country: "JP",
            line1: "3-6-7",
            line2: "青山パラシオタワー 11階",
            locality: "港区北青山",
            postalCode: "107-0061",
            subLocality: ""
          },
          dateOfBirth: "1985-06-30",
          emailAddress: "merchant-support@smartpay.co",
          firstName: "田中",
          firstNameKana: "たなか",
          lastName: "太郎",
          lastNameKana: "たろう",
          legalGender: "male",
          phoneNumber: nil,
          reference: nil
        },
        metadata: {},
        test: true
      })
    end
  end

  describe '#normalize_payload_promotion' do
    let(:request) do
      {
        items: [{
          name: "オリジナルス STAN SMITH",
          amount: 250,
          currency: "JPY",
          quantity: 1
        }],
        customer: {
          accountAge: 20,
          email: "merchant-support@smartpay.co",
          firstName: "田中",
          lastName: "太郎",
          firstNameKana: "たなか",
          lastNameKana: "たろう",
          address: {
            line1: "3-6-7",
            line2: "青山パラシオタワー 11階",
            subLocality: "",
            locality: "港区北青山",
            administrativeArea: "東京都",
            postalCode: "107-0061",
            country: "JP"
          },
          dateOfBirth: "1985-06-30",
          gender: "male"
        },
        shipping: {
          line1: "line1",
          locality: "locality",
          postalCode: "123",
          country: "JP"
        },
        reference: "order_ref_1234567",
        successURL: "https://docs.smartpay.co/example-pages/checkout-successful",
        cancelURL: "https://docs.smartpay.co/example-pages/checkout-canceled",
        promotionCode: "FOO",
        test: true
      }
    end

    it do
      expect(subject.send(:normalize_payload)).to eq({
        orderData: {
          amount: 250,
          captureMethod: nil,
          confirmationMethod: nil,
          coupons: nil,
          currency: "JPY",
          lineItemData: [{
            description: nil,
            metadata: nil,
            price: nil,
            priceData: {
              amount: 250,
              currency: "JPY",
              metadata: nil,
              productData: {
                brand: nil,
                categories: nil,
                description: nil,
                gtin: nil,
                images: nil,
                metadata: nil,
                name: "オリジナルス STAN SMITH",
                reference: nil,
                url: nil
              }
            },
            quantity: 1
          }],
          shippingInfo: {
            address: {
              administrativeArea: nil,
              country: "JP",
              line1: "line1",
              line2: nil,
              line3: nil,
              line4: nil,
              line5: nil,
              locality: "locality",
              postalCode: "123",
              subLocality: nil
            },
            addressType: nil,
            feeAmount: nil,
            feeCurrency: nil
          }
        },
        reference: "order_ref_1234567",
        successUrl: "https://docs.smartpay.co/example-pages/checkout-successful",
        cancelUrl: "https://docs.smartpay.co/example-pages/checkout-canceled",
        customerInfo: {
          accountAge: 20,
          address: {
            administrativeArea: "東京都",
            country: "JP",
            line1: "3-6-7",
            line2: "青山パラシオタワー 11階",
            locality: "港区北青山",
            postalCode: "107-0061",
            subLocality: ""
          },
          dateOfBirth: "1985-06-30",
          emailAddress: "merchant-support@smartpay.co",
          firstName: "田中",
          firstNameKana: "たなか",
          lastName: "太郎",
          lastNameKana: "たろう",
          legalGender: "male",
          phoneNumber: nil,
          reference: nil
        },
        metadata: {
          "__promotion_code__": "FOO"
        },
        test: true
      })
    end
  end


  describe '#normalize_customer_info' do
    let(:request) { {} }

    context 'when argument is nil' do
      it { expect(subject.send(:normalize_customer_info, nil)).to be nil }
    end

    context 'when argument is not nil' do
      it do
        expect(subject.send(:normalize_customer_info, { email: 'success@smartpay.co' })).to eq({
          accountAge: nil,
          address: nil,
          dateOfBirth: nil,
          emailAddress: "success@smartpay.co",
          firstName: nil,
          firstNameKana: nil,
          lastName: nil,
          lastNameKana: nil,
          legalGender: nil,
          phoneNumber: nil,
          reference: nil
        })
      end
    end
  end

  describe '#normalize_shipping' do
    let(:request) { {} }

    context 'when argument is nil' do
      it { expect(subject.send(:normalize_shipping, nil)).to be nil }
    end

    context 'when argument is not nil' do
      it do
        expect(subject.send(:normalize_shipping, { line1: 'line1' })).to eq({
          address: {
            administrativeArea: nil,
            country: nil,
            line1: "line1",
            line2: nil,
            line3: nil,
            line4: nil,
            line5: nil,
            locality: nil,
            postalCode: nil,
            subLocality: nil
          },
          addressType: nil,
          feeAmount: nil,
          feeCurrency: nil
        })
      end
    end
  end

  describe '#normalize_order_data' do
    let(:request) { {} }

    context 'when argument is nil' do
      it { expect(subject.send(:normalize_order_data, nil)).to be nil }
    end

    context 'when argument is not nil' do
      it do
        expect(subject.send(:normalize_order_data, { amount: 1 })).to eq({
          amount: 1,
          captureMethod: nil,
          confirmationMethod: nil,
          coupons: nil,
          currency: nil,
          lineItemData: [],
          shippingInfo: nil
        })
      end
    end
  end

  describe '#normalize_line_items' do
    let(:request) { {} }

    context 'when argument is nil' do
      it { expect(subject.send(:normalize_line_items, nil)).to eq([]) }
    end

    context 'when argument is not nil' do
      it do
        expect(subject.send(:normalize_line_items, [{ quantity: 1 }])).to eq([{
          description: nil,
          metadata: nil,
          price: nil,
          priceData: {
            amount: nil,
            currency: nil,
            metadata: nil,
            productData: {
              brand: nil,
              categories: nil,
              description: nil,
              gtin: nil,
              images: nil,
              metadata: nil,
              name: nil,
              reference: nil,
              url: nil
            }
          },
          quantity: 1
        }])
      end
    end
  end

  describe '#normalize_price_data' do
    let(:request) { {} }

    context 'when argument is nil' do
      it { expect(subject.send(:normalize_product_data, nil)).to be nil }
    end

    context 'when argument is not nil' do
      it do
        expect(subject.send(:normalize_price_data, { amount: 250, currency: 'JPY' })).to eq({
          amount: 250,
          currency: "JPY",
          metadata: nil,
          productData: { 
            brand: nil,
            categories: nil,
            description: nil,
            gtin: nil,
            images: nil,
            metadata: nil,
            name: nil,
            reference: nil,
            url: nil
          }
        })
      end
    end
  end

  describe '#normalize_product_data' do
    let(:request) { {} }

    context 'when argument is nil' do
      it { expect(subject.send(:normalize_product_data, nil)).to be nil }
    end

    context 'when argument is not nil' do
      it do
        expect(subject.send(:normalize_product_data, { "name" => "レブロン 18 LOW" })).to eq({
          brand: nil,
          categories: nil,
          description: nil,
          gtin: nil,
          images: nil,
          metadata: nil,
          name: 'レブロン 18 LOW',
          reference: nil,
          url: nil
        })
      end
    end
  end

  describe '#get_currency' do
    context 'with original backend api payload' do
      let(:request) do
        {
          items: [{
            name: "オリジナルス STAN SMITH",
            amount: 250,
            currency: "JPY",
            quantity: 1
          }],
          successURL: 'https://docs.smartpay.co/example-pages/checkout-successful',
          cancelURL: 'https://docs.smartpay.co/example-pages/checkout-canceled'
        }
      end
    end
  end
end
